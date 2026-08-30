import Foundation

public final class HistoryPlaybackTracker {
    public static let shared = HistoryPlaybackTracker()
    
    private init() {}
    
    public func previousWallpaper() -> WallpaperItem? {
        let history = HistoryManager.shared.history
        guard history.count > 1 else { return nil }
        return history[1]
    }
}
