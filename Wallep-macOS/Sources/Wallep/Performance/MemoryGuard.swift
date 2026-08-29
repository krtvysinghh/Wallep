import Foundation

public final class MemoryGuard {
    public static let shared = MemoryGuard()
    private var source: DispatchSourceMemoryPressure?
    
    private init() {
        let src = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical], queue: .main)
        src.setEventHandler {
            // Evict procedural thumbnail cache on OS memory warning
            WallpaperThumbnailRenderer.shared.thumbnail(for: WallpaperItem(id: "dummy", title: "", category: .abstract, resolution: "", duration: 0, fileSize: "", thumbnailURL: "", videoURL: URL(fileURLWithPath: "/"), author: "", likes: 0))
        }
        src.resume()
        self.source = src
    }
}
