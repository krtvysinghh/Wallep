import Cocoa
import AVFoundation
import Combine

public struct DisplayFeed {
    public let screen: NSScreen
    public let window: WallpaperWindow
    public let playerEngine: PlayerEngine
}

public final class WallpaperManager: NSObject, ObservableObject, PowerManagerDelegate {
    public static let shared = WallpaperManager()
    
    @Published public var displayFeeds: [DisplayFeed] = []
    @Published public var currentWallpaper: WallpaperItem?
    @Published public var isPlaybackActive: Bool = true
    @Published public var isAutoPausedForPower: Bool = false
    @Published public var isAutoPausedForFullScreen: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private override init() {
        super.init()
        PowerManager.shared.delegate = self
        setupScreenChangeObserver()
        reconfigureDisplays()
    }
    
    public func reconfigureDisplays() {
        // Clean up any existing feeds
        for feed in displayFeeds {
            feed.playerEngine.pause()
            feed.window.orderOut(nil)
        }
        displayFeeds.removeAll()
        
        // Spawn a native window & hardware-accelerated AVPlayerLayer for every physical screen
        for screen in NSScreen.screens {
            let window = WallpaperWindow(screen: screen)
            let engine = PlayerEngine(screenBounds: screen.frame)
            
            window.contentView = engine.containerView
            window.orderFront(nil)
            
            let feed = DisplayFeed(screen: screen, window: window, playerEngine: engine)
            displayFeeds.append(feed)
            
            // If we currently have a loaded wallpaper, load it into this new screen feed
            if let wallpaper = currentWallpaper {
                engine.loadVideo(url: wallpaper.videoURL, loop: true, crossfade: false)
            }
        }
    }
    
    public func setWallpaper(_ item: WallpaperItem, forScreen screen: NSScreen? = nil) {
        self.currentWallpaper = item
        
        for feed in displayFeeds {
            if screen == nil || feed.screen == screen {
                feed.playerEngine.loadWallpaper(item, loop: true, crossfade: true)
                if !shouldPausePlayback() {
                    feed.playerEngine.play()
                }
            }
        }
        self.isPlaybackActive = !shouldPausePlayback()
    }
    
    public func togglePlayPause() {
        if isPlaybackActive {
            pauseAll()
        } else {
            resumeAll()
        }
    }
    
    public func pauseAll() {
        for feed in displayFeeds {
            feed.playerEngine.pause()
        }
        self.isPlaybackActive = false
    }
    
    public func resumeAll() {
        guard !shouldPausePlayback() else { return }
        for feed in displayFeeds {
            feed.playerEngine.play()
        }
        self.isPlaybackActive = true
    }
    
    public func setMuted(_ isMuted: Bool) {
        for feed in displayFeeds {
            feed.playerEngine.setMuted(isMuted)
        }
    }
    
    public func setVolume(_ volume: Float) {
        for feed in displayFeeds {
            feed.playerEngine.setVolume(volume)
        }
    }
    
    private func shouldPausePlayback() -> Bool {
        if PowerManager.shared.isSystemSleeping { return true }
        if PowerManager.shared.pauseOnBattery && (PowerManager.shared.isOnBattery || PowerManager.shared.isLowPowerMode) {
            return true
        }
        if isAutoPausedForFullScreen {
            return true
        }
        return false
    }
    
    private func setupScreenChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenParametersChanged),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
    
    @objc private func handleScreenParametersChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.reconfigureDisplays()
        }
    }
    
    // MARK: - PowerManagerDelegate
    
    public func powerStateDidChange(isOnBattery: Bool, isLowPowerMode: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if PowerManager.shared.pauseOnBattery && (isOnBattery || isLowPowerMode) {
                self.isAutoPausedForPower = true
                self.pauseAll()
            } else {
                if self.isAutoPausedForPower {
                    self.isAutoPausedForPower = false
                    self.resumeAll()
                }
            }
        }
    }
    
    public func systemWillSleep() {
        DispatchQueue.main.async { [weak self] in
            self?.pauseAll()
        }
    }
    
    public func systemDidWake() {
        DispatchQueue.main.async { [weak self] in
            self?.resumeAll()
        }
    }
    
    public func activeAppDidChange(isFullScreenAppActive: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isAutoPausedForFullScreen = isFullScreenAppActive
            if isFullScreenAppActive {
                self.pauseAll()
            } else {
                self.resumeAll()
            }
        }
    }
}
