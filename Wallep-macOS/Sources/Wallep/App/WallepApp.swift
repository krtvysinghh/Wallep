import Cocoa
import SwiftUI

public final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    public static var shared: AppDelegate?
    
    public var statusItem: NSStatusItem?
    public var statusPopover: NSPopover?
    public var mainWindow: NSWindow?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        
        // Ensure regular foreground application activation
        NSApp.setActivationPolicy(.regular)
        
        // Initialize wallpaper windows
        _ = WallpaperManager.shared
        
        // Setup status bar item
        setupStatusBarItem()
        
        // Create and show main window
        setupMainWindow()
        AppDelegate.showMainWindow()
    }
    
    private func setupStatusBarItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = item.button {
            button.image = NSImage(systemSymbolName: "sparkles.rectangle.stack.fill", accessibilityDescription: "Wallep")
            button.target = self
            button.action = #selector(togglePopover(_:))
        }
        self.statusItem = item
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 330, height: 430)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuBarView())
        self.statusPopover = popover
    }
    
    @objc public func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem?.button, let popover = statusPopover else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    public func setupMainWindow() {
        if mainWindow != nil { return }
        
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
        window.delegate = self
        window.contentView = NSHostingView(rootView: MainAppView())
        self.mainWindow = window
    }
    
    public static func showMainWindow(tab: ActiveTab? = nil) {
        if let t = tab {
            AppState.shared.activeTab = t
        }
        guard let delegate = AppDelegate.shared else { return }
        if delegate.mainWindow == nil {
            delegate.setupMainWindow()
        }
        if let win = delegate.mainWindow {
            win.makeKeyAndOrderFront(nil)
            win.center()
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    // When red close button is clicked, hide window instead of destroying it
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }
    
    // When clicking Dock icon, show main window
    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        AppDelegate.showMainWindow()
        return true
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

public struct MainEntryPoint {
    public static func main() {
        if CLIHandler.handle(arguments: CommandLine.arguments) {
            exit(0)
        }
        
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
