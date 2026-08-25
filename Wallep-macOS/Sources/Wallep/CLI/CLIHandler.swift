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
            for item in library.wallpapers {
                print("  • [\(item.id)] \(item.title) (\(item.category.rawValue)) - \(item.resolution)")
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
            
        default:
            return false
        }
    }
}
