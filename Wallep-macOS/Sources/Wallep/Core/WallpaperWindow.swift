import Cocoa
import AVFoundation

public final class WallpaperWindow: NSWindow {
    public let targetScreen: NSScreen
    
    public init(screen: NSScreen) {
        self.targetScreen = screen
        
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
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
        self.setFrame(screen.frame, display: true)
    }
}
