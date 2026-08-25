import Cocoa
import AVFoundation

public final class WallpaperWindow: NSWindow {
    public var targetScreen: NSScreen
    
    public init(screen: NSScreen) {
        self.targetScreen = screen
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        setupWindowAttributes()
    }
    
    override public init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        self.targetScreen = NSScreen.main ?? (NSScreen.screens.first ?? NSScreen())
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: backingStoreType,
            defer: flag
        )
        setupWindowAttributes()
    }
    
    private func setupWindowAttributes() {
        // Pin window directly to the macOS Desktop level (beneath icons and desktop windows)
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        
        // Critical: Keeps wallpaper fixed during Space switching and Mission Control
        self.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle,
            .fullScreenAuxiliary
        ]
        
        // Mouse and keyboard transparency - all clicks pass straight through to desktop files/icons
        self.ignoresMouseEvents = true
        self.acceptsMouseMovedEvents = false
        
        // Visual configuration
        self.isOpaque = true
        self.hasShadow = false
        self.backgroundColor = .black
        self.isReleasedWhenClosed = false
        self.hidesOnDeactivate = false
        
        // Position exactly matching the assigned physical display screen
        self.setFrame(targetScreen.frame, display: true)
    }
    
    override public var canBecomeKey: Bool { false }
    override public var canBecomeMain: Bool { false }
    
    public func updateFrame(for screen: NSScreen) {
        self.targetScreen = screen
        self.setFrame(screen.frame, display: true)
    }
}
