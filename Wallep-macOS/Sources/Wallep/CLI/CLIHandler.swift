import Foundation
import Cocoa

public struct CLIHandler {
    public static func handle(arguments: [String]) -> Bool {
        guard arguments.count > 1 else { return false }
        
        let command = arguments[1]
        switch command {
        case "--help", "-h", "help":
            print("""
            Wallep — Open Source 4K Live Wallpapers for macOS
            
            Usage:
              wallep                    Launch Wallep GUI & MenuBar
              wallep list               List all available live wallpapers
              wallep set <path_or_id>   Set wallpaper by local file path or ID
              wallep pause              Pause wallpaper playback
              wallep resume             Resume wallpaper playback
              wallep status             Show active screens and power status
              wallep --version          Show version
            """)
            return true
            
        case "--version", "-v":
            print("Wallep v1.0.0 (Apple Silicon / Intel macOS 14.6+ Native)")
            return true
            
        case "list":
            let library = LibraryManager.shared
            print("Available 4K Wallpapers (\(library.wallpapers.count)):")
            for item in library.wallpapers.prefix(100) {
                print("  • [\(item.id)] \(item.title) (\(item.category.rawValue)) - \(item.resolution)")
            }
            if library.wallpapers.count > 100 {
                print("  ... and \(library.wallpapers.count - 100) more wallpapers.")
            }
            return true
            
        case "status":
            let pm = PowerManager.shared
            print("Wallep Status:")
            print("  Power Source: \(pm.isOnBattery ? "Battery (Power-Save Mode)" : "AC Power Connected")")
            print("  Displays Active: \(NSScreen.screens.count)")
            for (idx, screen) in NSScreen.screens.enumerated() {
                print("    Screen #\(idx + 1): \(Int(screen.frame.width))x\(Int(screen.frame.height))")
            }
            return true
            
        case "pause":
            WallpaperManager.shared.pauseAll()
            print("Wallep playback paused.")
            return true
            
        case "resume":
            WallpaperManager.shared.resumeAll()
            print("Wallep playback resumed.")
            return true
            
        case "set":
            guard arguments.count > 2 else {
                print("Error: Missing wallpaper ID or file path. Usage: wallep set <id_or_path>")
                return true
            }
            let target = arguments[2]
            let library = LibraryManager.shared
            if let matched = library.wallpapers.first(where: { $0.id == target || $0.title.localizedCaseInsensitiveContains(target) }) {
                WallpaperManager.shared.setWallpaper(matched)
                print("Applied wallpaper: \(matched.title) (\(matched.id))")
            } else {
                let fileURL = URL(fileURLWithPath: target)
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    if let custom = library.importCustomVideo(at: fileURL) {
                        WallpaperManager.shared.setWallpaper(custom)
                        print("Imported and applied: \(custom.title)")
                    } else {
                        print("Error: Could not import file at \(target)")
                    }
                } else {
                    print("Error: Wallpaper ID or file not found: \(target)")
                }
            }
            return true
            
        default:
            print("Unknown command: '\(command)'. Run 'wallep --help' for usage.")
            return true
        }
    }
}
