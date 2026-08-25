import Foundation
import Combine
import AVFoundation
import Cocoa

public final class LibraryManager: ObservableObject {
    public static let shared = LibraryManager()
    
    @Published public var wallpapers: [WallpaperItem] = []
    @Published public var selectedCategory: WallpaperCategory = .all
    @Published public var searchQuery: String = ""
    @Published public var isGeneratingDefaults: Bool = false
    
    public let storageDirectory: URL
    private let allowedExtensions = Set(["mp4", "mov", "m4v", "webm"])
    
    private init() {
        let fileManager = FileManager.default
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        self.storageDirectory = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        
        try? fileManager.createDirectory(at: storageDirectory, withIntermediateDirectories: true)
        
        // Populate preset metadata synchronously
        self.wallpapers = DefaultWallpaperGenerator.shared.presets.map { preset in
            let videoURL = self.storageDirectory.appendingPathComponent("\(preset.id).mp4")
            let thumbURL = self.storageDirectory.appendingPathComponent("\(preset.id).jpg")
            return WallpaperItem(
                id: preset.id,
                title: preset.title,
                category: preset.category,
                resolution: "3840x2160 (Native 4K)",
                duration: 6.0,
                fileSize: "12.4MB",
                thumbnailURL: thumbURL.path,
                videoURL: videoURL,
                author: preset.author,
                likes: preset.likes,
                isFavorite: true,
                isCustom: false
            )
        }
        
        loadLibrary()
    }
    
    public var filteredWallpapers: [WallpaperItem] {
        wallpapers.filter { item in
            let matchesCategory = (selectedCategory == .all || item.category == selectedCategory)
            let matchesSearch = searchQuery.isEmpty || 
                item.title.localizedCaseInsensitiveContains(searchQuery) || 
                item.author.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesSearch
        }
    }
    
    public func importCustomVideo(at sourceURL: URL, title: String? = nil, category: WallpaperCategory = .abstract, completion: ((WallpaperItem?) -> Void)? = nil) -> WallpaperItem? {
        let ext = sourceURL.pathExtension.lowercased()
        guard allowedExtensions.contains(ext) else {
            print("[Wallep] Disallowed file extension: .\(ext)")
            completion?(nil)
            return nil
        }
        
        let fileUUID = UUID().uuidString
        let sanitizedName = fileUUID + "_" + sourceURL.lastPathComponent.replacingOccurrences(of: "..", with: "")
        let destURL = storageDirectory.appendingPathComponent(sanitizedName)
        let thumbURL = storageDirectory.appendingPathComponent("\(fileUUID)_thumb.jpg")
        
        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            
            // Extract accurate video metadata
            let asset = AVURLAsset(url: destURL)
            let durationSeconds = CMTimeGetSeconds(asset.duration)
            
            var resString = "3840x2160 (Native 4K)"
            if let track = asset.tracks(withMediaType: .video).first {
                let size = track.naturalSize.applying(track.preferredTransform)
                let w = Int(abs(size.width))
                let h = Int(abs(size.height))
                resString = "\(w)x\(h)"
                if w >= 3840 || h >= 2160 {
                    resString += " (4K UHD)"
                } else if w >= 2560 || h >= 1440 {
                    resString += " (2K QHD)"
                } else if w >= 1920 || h >= 1080 {
                    resString += " (1080p FHD)"
                }
            }
            
            let fileAttrs = try? FileManager.default.attributesOfItem(atPath: destURL.path)
            let rawBytes = (fileAttrs?[.size] as? NSNumber)?.int64Value ?? 0
            let mb = max(0.1, Double(rawBytes) / (1024.0 * 1024.0))
            
            // Generate visual thumbnail frame
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 640, height: 360)
            
            let time = CMTime(seconds: min(1.0, durationSeconds / 2), preferredTimescale: 600)
            if let cgImg = try? generator.copyCGImage(at: time, actualTime: nil) {
                let rep = NSBitmapImageRep(cgImage: cgImg)
                if let jpg = rep.representation(using: .jpeg, properties: [:]) {
                    try? jpg.write(to: thumbURL)
                }
            }
            
            let item = WallpaperItem(
                id: fileUUID,
                title: title ?? sourceURL.deletingPathExtension().lastPathComponent,
                category: category,
                resolution: resString,
                duration: durationSeconds > 0 ? durationSeconds : 45.0,
                fileSize: "\(String(format: "%.1f", mb))MB",
                thumbnailURL: FileManager.default.fileExists(atPath: thumbURL.path) ? thumbURL.path : "",
                videoURL: destURL,
                author: "Local Import",
                likes: 0,
                isFavorite: true,
                isCustom: true
            )
            
            DispatchQueue.main.async {
                self.wallpapers.insert(item, at: 0)
                completion?(item)
            }
            return item
        } catch {
            print("[Wallep] Failed to securely import video: \(error.localizedDescription)")
            completion?(nil)
            return nil
        }
    }
    
    public func toggleFavorite(for id: String) {
        if let idx = wallpapers.firstIndex(where: { $0.id == id }) {
            wallpapers[idx].isFavorite.toggle()
        }
    }
    
    private func loadLibrary() {
        self.isGeneratingDefaults = true
        DefaultWallpaperGenerator.shared.ensureDefaultWallpapers(in: storageDirectory) { [weak self] items in
            guard let self = self else { return }
            self.wallpapers = items
            self.isGeneratingDefaults = false
            
            // If WallpaperManager has no wallpaper set, set first default
            if WallpaperManager.shared.currentWallpaper == nil, let first = items.first {
                WallpaperManager.shared.setWallpaper(first)
            }
        }
    }
}
