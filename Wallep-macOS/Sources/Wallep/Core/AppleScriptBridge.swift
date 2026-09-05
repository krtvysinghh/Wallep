import Foundation

public final class AppleScriptBridge {
    public static let shared = AppleScriptBridge()
    
    public func executeCommand(_ command: String) -> String {
        switch command.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "next":
            WallpaperManager.shared.nextWallpaper()
            return "SUCCESS: Advanced to next wallpaper"
        case "prev", "previous":
            WallpaperManager.shared.previousWallpaper()
            return "SUCCESS: Reverted to previous wallpaper"
        case "pause":
            WallpaperManager.shared.pause()
            return "SUCCESS: Playback paused"
        case "resume", "play":
            WallpaperManager.shared.resume()
            return "SUCCESS: Playback resumed"
        case "toggle":
            WallpaperManager.shared.togglePlayPause()
            return "SUCCESS: Playback toggled"
        case "status":
            let current = WallpaperManager.shared.currentWallpaper?.title ?? "None"
            return "STATUS: Current wallpaper is '\(current)'"
        default:
            return "ERROR: Unknown command '\(command)'"
        }
    }
}
