import Foundation
import Combine

public final class LibraryManager: ObservableObject {
    public static let shared = LibraryManager()
    
    @Published public var wallpapers: [WallpaperItem] = []
    @Published public var selectedCategory: WallpaperCategory = .all
    @Published public var searchQuery: String = ""
    
    public let storageDirectory: URL
    private let allowedExtensions = Set(["mp4", "mov", "m4v", "webm"])
    
    private init() {
        let fileManager = FileManager.default
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        self.storageDirectory = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        
        try? fileManager.createDirectory(at: storageDirectory, withIntermediateDirectories: true)
        loadDefaultLibrary()
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
    
    public func importCustomVideo(at sourceURL: URL, title: String? = nil, category: WallpaperCategory = .abstract) -> WallpaperItem? {
        let ext = sourceURL.pathExtension.lowercased()
        guard allowedExtensions.contains(ext) else {
            print("[Wallep] Disallowed file extension: .\(ext)")
            return nil
        }
        
        // Sanitize file name to prevent path traversal
        let sanitizedName = UUID().uuidString + "_" + sourceURL.lastPathComponent.replacingOccurrences(of: "..", with: "")
        let destURL = storageDirectory.appendingPathComponent(sanitizedName)
        
        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            
            let fileAttrs = try? FileManager.default.attributesOfItem(atPath: destURL.path)
            let rawBytes = (fileAttrs?[.size] as? NSNumber)?.int64Value ?? 0
            let mb = Double(rawBytes) / (1024.0 * 1024.0)

            let item = WallpaperItem(
                title: title ?? sourceURL.deletingPathExtension().lastPathComponent,
                category: category,
                resolution: "Custom (Native 4K)",
                duration: 45.0,
                fileSize: "\(String(format: "%.1f", mb))MB",
                thumbnailURL: "",
                videoURL: destURL,
                author: "Local Import",
                likes: 0,
                isFavorite: true,
                isCustom: true
            )
            
            if Thread.isMainThread {
                self.wallpapers.insert(item, at: 0)
            } else {
                DispatchQueue.main.sync {
                    self.wallpapers.insert(item, at: 0)
                }
            }
            return item
        } catch {
            print("[Wallep] Failed to securely import video: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func toggleFavorite(for id: String) {
        if let idx = wallpapers.firstIndex(where: { $0.id == id }) {
            wallpapers[idx].isFavorite.toggle()
        }
    }
    
    private func loadDefaultLibrary() {
        let sampleCatalog: [WallpaperItem] = [
            WallpaperItem(
                id: "sample_01",
                title: "Cat in Rain (Lo-Fi Cozy)",
                category: .anime,
                resolution: "3840x2160 (4K)",
                duration: 90.0,
                fileSize: "25MB",
                thumbnailURL: "/images/wallpapers/cat_rain.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-cat-looking-out-the-window-in-the-rain-41551-large.mp4")!,
                author: "Studio Ghibli Vibes",
                likes: 441
            ),
            WallpaperItem(
                id: "sample_02",
                title: "Orchid in the Rain",
                category: .nature,
                resolution: "3840x2160 (4K UHD)",
                duration: 120.0,
                fileSize: "40MB",
                thumbnailURL: "/images/wallpapers/orchid.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-rain-falling-on-the-leaves-of-a-plant-41552-large.mp4")!,
                author: "Wallep Nature Lab",
                likes: 456
            ),
            WallpaperItem(
                id: "sample_03",
                title: "Cyberpunk Neo Tokyo",
                category: .cyberpunk,
                resolution: "3840x2160 (4K HDR)",
                duration: 75.0,
                fileSize: "48MB",
                thumbnailURL: "/images/wallpapers/cyberpunk.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-futuristic-city-with-flying-cars-and-skyscrapers-41553-large.mp4")!,
                author: "Neon Dreams",
                likes: 1289
            ),
            WallpaperItem(
                id: "sample_04",
                title: "Porsche GT3 High Speed Run",
                category: .cars,
                resolution: "3840x2160 (4K 60FPS)",
                duration: 45.0,
                fileSize: "30MB",
                thumbnailURL: "/images/wallpapers/porsche.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-driving-on-a-highway-at-sunset-41554-large.mp4")!,
                author: "Apex Velocity",
                likes: 890
            ),
            WallpaperItem(
                id: "sample_05",
                title: "Deep Cosmos Nebula Loop",
                category: .space,
                resolution: "3840x2160 (4K)",
                duration: 180.0,
                fileSize: "62MB",
                thumbnailURL: "/images/wallpapers/nebula.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-flying-through-a-starfield-in-space-41555-large.mp4")!,
                author: "Interstellar",
                likes: 673
            ),
            WallpaperItem(
                id: "sample_06",
                title: "Minimalist Aurora Borealis",
                category: .minimalist,
                resolution: "3840x2160 (4K)",
                duration: 95.0,
                fileSize: "28MB",
                thumbnailURL: "/images/wallpapers/aurora.jpg",
                videoURL: URL(string: "https://assets.mixkit.co/videos/preview/mixkit-northern-lights-over-a-snowy-forest-41556-large.mp4")!,
                author: "Nordic Ambient",
                likes: 512
            )
        ]
        self.wallpapers = sampleCatalog
    }
}
