import SwiftUI
import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        
        // Show main window on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApplication.shared.windows.first(where: { $0.title == "Wallep" || $0.identifier?.rawValue == "main-window" }) {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows where !(window is WallpaperWindow) {
                window.makeKeyAndOrderFront(nil)
                return true
            }
        }
        return true
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep running in background / MenuBar even if main window is closed
        return false
    }
}

@main
public struct WallepApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
        Window("Wallep", id: "main-window") {
            MainAppView()
                .onAppear {
                    NSApp.activate(ignoringOtherApps: true)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1080, height: 720)
    }
}
