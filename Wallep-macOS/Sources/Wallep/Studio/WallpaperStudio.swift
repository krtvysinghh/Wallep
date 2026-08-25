import Foundation
import AVFoundation

public struct StudioProject: Identifiable, Codable {
    public let id: String
    public var title: String
    public var baseVideoURL: URL
    public var audioTrackURL: URL?
    public var brightness: Float // -1.0 to 1.0
    public var contrast: Float   // 0.0 to 2.0
    public var saturation: Float // 0.0 to 2.0
    public var speed: Float      // 0.25 to 2.0
    public var loopDuration: TimeInterval
    
    public init(
        id: String = UUID().uuidString,
        title: String = "Untitled Live Wallpaper",
        baseVideoURL: URL,
        audioTrackURL: URL? = nil,
        brightness: Float = 0.0,
        contrast: Float = 1.0,
        saturation: Float = 1.0,
        speed: Float = 1.0,
        loopDuration: TimeInterval = 30.0
    ) {
        self.id = id
        self.title = title
        self.baseVideoURL = baseVideoURL
        self.audioTrackURL = audioTrackURL
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.speed = speed
        self.loopDuration = loopDuration
    }
}

public final class WallpaperStudio: ObservableObject {
    public static let shared = WallpaperStudio()
    
    @Published public var currentProject: StudioProject?
    @Published public var isExporting: Bool = false
    @Published public var exportProgress: Double = 0.0
    
    public init() {}
    
    public func createProject(with videoURL: URL) {
        self.currentProject = StudioProject(
            title: videoURL.deletingPathExtension().lastPathComponent,
            baseVideoURL: videoURL
        )
    }
    
    public func exportWallpaper(to destinationURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let project = currentProject else {
            completion(.failure(NSError(domain: "WallepStudio", code: 400, userInfo: [NSLocalizedDescriptionKey: "No active studio project"])))
            return
        }
        
        self.isExporting = true
        self.exportProgress = 0.1
        
        let asset = AVURLAsset(url: project.baseVideoURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            self.isExporting = false
            completion(.failure(NSError(domain: "WallepStudio", code: 500, userInfo: [NSLocalizedDescriptionKey: "Export session creation failed"])))
            return
        }
        
        exportSession.outputURL = destinationURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] t in
            guard let self = self else { return }
            self.exportProgress = Double(exportSession.progress)
        }
        
        exportSession.exportAsynchronously { [weak self] in
            timer.invalidate()
            DispatchQueue.main.async {
                self?.isExporting = false
                self?.exportProgress = 1.0
                
                if exportSession.status == .completed {
                    completion(.success(destinationURL))
                } else {
                    completion(.failure(exportSession.error ?? NSError(domain: "WallepStudio", code: 500, userInfo: [NSLocalizedDescriptionKey: "Export failed"])))
                }
            }
        }
    }
}
