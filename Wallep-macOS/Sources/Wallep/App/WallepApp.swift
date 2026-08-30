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
        
        // Build complete native macOS Main Menu Bar
        setupMainMenu()
        
        // Initialize wallpaper windows and feeds
        _ = WallpaperManager.shared
        
        // Setup status bar item in macOS top-right menu bar
        setupStatusBarItem()
        
        // Register global keyboard shortcuts
        KeyboardShortcutsManager.shared.registerGlobalShortcuts()
        
        // Create and show main GUI window
        setupMainWindow()
        AppDelegate.showMainWindow()
    }
    
    // MARK: - Native macOS Top Menu Bar
    private func setupMainMenu() {
        let mainMenu = NSMenu()
        
        // 1. App Menu (Wallep)
        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu(title: "Wallep")
        
        appMenu.addItem(withTitle: "About Wallep", action: #selector(openAbout(_:)), keyEquivalent: "")
        appMenu.addItem(withTitle: "Preferences...", action: #selector(openPreferences(_:)), keyEquivalent: ",")
        appMenu.addItem(NSMenuItem.separator())
        
        let servicesItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        let servicesMenu = NSMenu(title: "Services")
        servicesItem.submenu = servicesMenu
        NSApp.servicesMenu = servicesMenu
        appMenu.addItem(servicesItem)
        appMenu.addItem(NSMenuItem.separator())
        
        appMenu.addItem(withTitle: "Hide Wallep", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        let hideOthers = appMenu.addItem(withTitle: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthers.keyEquivalentModifierMask = [.command, .option]
        appMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        
        appMenu.addItem(withTitle: "Quit Wallep", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        // 2. File Menu
        let fileMenuItem = NSMenuItem()
        let fileMenu = NSMenu(title: "File")
        fileMenu.addItem(withTitle: "Import Custom Video...", action: #selector(importCustomVideo(_:)), keyEquivalent: "o")
        fileMenu.addItem(withTitle: "Open Wallpapers Directory", action: #selector(openStorageFolder(_:)), keyEquivalent: "O")
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(withTitle: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
        fileMenuItem.submenu = fileMenu
        mainMenu.addItem(fileMenuItem)
        
        // 3. Edit Menu
        let editMenuItem = NSMenuItem()
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editMenuItem.submenu = editMenu
        mainMenu.addItem(editMenuItem)
        
        // 4. Wallpaper Menu
        let wallpaperMenuItem = NSMenuItem()
        let wallpaperMenu = NSMenu(title: "Wallpaper")
        
        let nextItem = wallpaperMenu.addItem(withTitle: "Next Wallpaper", action: #selector(nextWallpaperAction(_:)), keyEquivalent: "n")
        nextItem.keyEquivalentModifierMask = [.command, .option]
        
        let prevItem = wallpaperMenu.addItem(withTitle: "Previous Wallpaper", action: #selector(previousWallpaperAction(_:)), keyEquivalent: "p")
        prevItem.keyEquivalentModifierMask = [.command, .option]
        
        let playPauseItem = wallpaperMenu.addItem(withTitle: "Play / Pause Playback", action: #selector(togglePlaybackAction(_:)), keyEquivalent: " ")
        playPauseItem.keyEquivalentModifierMask = [.command, .option]
        
        let muteItem = wallpaperMenu.addItem(withTitle: "Mute / Unmute Audio", action: #selector(toggleMuteAction(_:)), keyEquivalent: "m")
        muteItem.keyEquivalentModifierMask = [.command, .option]
        
        let autoChangeItem = wallpaperMenu.addItem(withTitle: "Toggle Auto-Change", action: #selector(toggleAutoChangeAction(_:)), keyEquivalent: "a")
        autoChangeItem.keyEquivalentModifierMask = [.command, .option]
        
        wallpaperMenu.addItem(NSMenuItem.separator())
        wallpaperMenu.addItem(withTitle: "4K Wallpaper Gallery", action: #selector(openGalleryTab(_:)), keyEquivalent: "1")
        wallpaperMenu.addItem(withTitle: "Wallpaper Studio", action: #selector(openStudioTab(_:)), keyEquivalent: "2")
        wallpaperMenu.addItem(withTitle: "Preferences & Display Settings", action: #selector(openSettingsTab(_:)), keyEquivalent: "3")
        
        wallpaperMenuItem.submenu = wallpaperMenu
        mainMenu.addItem(wallpaperMenuItem)
        
        // 5. Displays Menu
        let displaysMenuItem = NSMenuItem()
        let displaysMenu = NSMenu(title: "Displays")
        displaysMenu.addItem(withTitle: "Reconfigure Multi-Monitor Feeds", action: #selector(reconfigureDisplaysAction(_:)), keyEquivalent: "r")
        displaysMenuItem.submenu = displaysMenu
        mainMenu.addItem(displaysMenuItem)
        
        // 6. Window Menu
        let windowMenuItem = NSMenuItem()
        let windowMenu = NSMenu(title: "Window")
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
        windowMenu.addItem(NSMenuItem.separator())
        windowMenu.addItem(withTitle: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: "")
        windowMenuItem.submenu = windowMenu
        mainMenu.addItem(windowMenuItem)
        
        // 7. Help Menu
        let helpMenuItem = NSMenuItem()
        let helpMenu = NSMenu(title: "Help")
        helpMenu.addItem(withTitle: "Wallep Documentation", action: #selector(openDocs(_:)), keyEquivalent: "")
        helpMenu.addItem(withTitle: "Keyboard Shortcuts Guide", action: #selector(openShortcutsGuide(_:)), keyEquivalent: "/")
        helpMenu.addItem(withTitle: "GitHub Repository", action: #selector(openGitHub(_:)), keyEquivalent: "")
        helpMenu.addItem(withTitle: "Report an Issue...", action: #selector(reportIssue(_:)), keyEquivalent: "")
        helpMenuItem.submenu = helpMenu
        mainMenu.addItem(helpMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
    
    // MARK: - Status Bar Item (Top Right)
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
    
    // MARK: - Actions
    @objc public func openAbout(_ sender: Any?) {
        let alert = NSAlert()
        alert.messageText = "Wallep v1.1.0"
        alert.informativeText = "100% Free & Open Source Native 4K Live Wallpaper Engine for macOS.\n\nDesigned for Apple Silicon & Intel Mac."
        alert.alertStyle = .informational
        alert.runModal()
    }
    
    @objc public func openPreferences(_ sender: Any?) {
        AppDelegate.showMainWindow(tab: .settings)
    }
    
    @objc public func importCustomVideo(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.movie, .quickTimeMovie, .mpeg4Movie]
        if panel.runModal() == .OK, let url = panel.url {
            _ = LibraryManager.shared.importCustomVideo(at: url)
        }
    }
    
    @objc public func openStorageFolder(_ sender: Any?) {
        NSWorkspace.shared.open(LibraryManager.shared.storageDirectory)
    }
    
    @objc public func nextWallpaperAction(_ sender: Any?) {
        AutoChangeManager.shared.triggerNextWallpaper()
    }
    
    @objc public func previousWallpaperAction(_ sender: Any?) {
        if let prev = HistoryPlaybackTracker.shared.previousWallpaper() {
            WallpaperManager.shared.setWallpaper(prev)
        }
    }
    
    @objc public func togglePlaybackAction(_ sender: Any?) {
        AppState.shared.togglePlayback()
    }
    
    @objc public func toggleMuteAction(_ sender: Any?) {
        AppState.shared.isMuted.toggle()
    }
    
    @objc public func toggleAutoChangeAction(_ sender: Any?) {
        AutoChangeManager.shared.isEnabled.toggle()
    }
    
    @objc public func openGalleryTab(_ sender: Any?) {
        AppDelegate.showMainWindow(tab: .gallery)
    }
    
    @objc public func openStudioTab(_ sender: Any?) {
        AppDelegate.showMainWindow(tab: .studio)
    }
    
    @objc public func openSettingsTab(_ sender: Any?) {
        AppDelegate.showMainWindow(tab: .settings)
    }
    
    @objc public func reconfigureDisplaysAction(_ sender: Any?) {
        WallpaperManager.shared.reconfigureDisplays()
    }
    
    @objc public func openDocs(_ sender: Any?) {
        if let url = URL(string: "https://github.com/krtvysinghh/wallep#readme") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc public func openShortcutsGuide(_ sender: Any?) {
        if let url = URL(string: "https://github.com/krtvysinghh/wallep/blob/main/docs/CLI_MANUAL.md") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc public func openGitHub(_ sender: Any?) {
        if let url = URL(string: "https://github.com/krtvysinghh/wallep") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc public func reportIssue(_ sender: Any?) {
        if let url = URL(string: "https://github.com/krtvysinghh/wallep/issues/new") {
            NSWorkspace.shared.open(url)
        }
    }
    
    public func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }
    
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
