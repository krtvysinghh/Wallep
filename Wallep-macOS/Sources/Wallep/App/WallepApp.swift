import SwiftUI
import AppKit

@main
public struct WallepApp: App {
    @StateObject private var appState = AppState.shared
    
    public init() {
        if CLIHandler.handle(arguments: CommandLine.arguments) {
            exit(0)
        }
        // Initialize wallpaper windows
        _ = WallpaperManager.shared
    }
    
    public var body: some Scene {
        // MenuBar status item
        MenuBarExtra("Wallep", systemImage: "sparkles.rectangle.stack.fill") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
        
        // Main Window (Gallery, Studio, Settings)
        WindowGroup("Wallep", id: "main-window") {
            MainAppView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1080, height: 720)
    }
}
