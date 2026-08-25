import SwiftUI
import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public static var mainWindow: NSWindow?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppDelegate.showMainWindow()
        }
    }
    
    public static func showMainWindow() {
        if let win = mainWindow, win.isVisible {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        if let existing = NSApplication.shared.windows.first(where: { 
            !($0 is WallpaperWindow) && $0.className != "NSStatusBarWindow" && $0.level == .normal 
        }) {
            mainWindow = existing
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1100, height: 740),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Wallep"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.center()
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: MainAppView())
        mainWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AppDelegate.showMainWindow()
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
