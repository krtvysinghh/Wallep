import Cocoa
import AVFoundation

public final class PlayerEngine: NSObject, ObservableObject {
    public let player: AVQueuePlayer
    private var playerLooper: AVPlayerLooper?
    public let playerLayer: AVPlayerLayer
    public let containerView: NSView
    public let screenBounds: NSRect
    
    @Published public var isPlaying: Bool = false
    @Published public var isMuted: Bool = true
    @Published public var volume: Float = 0.0
    @Published public var currentItem: WallpaperItem?
    
    private var thermalObserver: NSObjectProtocol?
    
    public init(screenBounds: NSRect) {
        self.screenBounds = screenBounds
        self.player = AVQueuePlayer()
        self.player.isMuted = true
        self.player.volume = 0.0
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.actionAtItemEnd = .none
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.frame = screenBounds
        self.playerLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        
        self.containerView = NSView(frame: screenBounds)
        self.containerView.wantsLayer = true
        self.containerView.layer = CALayer()
        self.containerView.layer?.backgroundColor = NSColor(calibratedWhite: 0.05, alpha: 1.0).cgColor
        self.containerView.layer?.contentsGravity = .resizeAspectFill
        self.containerView.layer?.addSublayer(self.playerLayer)
        
        super.init()
        
        setupNotificationObservers()
        setupThermalObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let observer = thermalObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        player.pause()
        player.removeAllItems()
    }
    
    public func updateBounds(_ bounds: NSRect) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.containerView.frame = bounds
        self.playerLayer.frame = bounds
        CATransaction.commit()
    }
    
    public func loadWallpaper(_ item: WallpaperItem, loop: Bool = true, crossfade: Bool = true) {
        self.currentItem = item
        
        // 1. Immediately paint high-res procedural artwork onto container canvas (Zero black screen!)
        let thumb = WallpaperThumbnailRenderer.shared.thumbnail(for: item, size: CGSize(width: max(1920, screenBounds.width * 2), height: max(1080, screenBounds.height * 2)))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.containerView.layer?.contents = thumb.cgImage(forProposedRect: nil, context: nil, hints: nil)
        CATransaction.commit()
        
        // 2. Resolve video URL
        var effectiveURL = item.videoURL
        if item.videoURL.scheme == "wallep" || !FileManager.default.fileExists(atPath: item.videoURL.path) {
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let defaultDir = appSupport.appendingPathComponent("Wallep", isDirectory: true)
            
            // Choose closest matching preset for category
            let presetName: String
            switch item.category {
            case .cyberpunk, .cars:
                presetName = "default_cyberpunk.mp4"
            case .nature:
                presetName = "default_aurora.mp4"
            case .space:
                presetName = "default_nebula.mp4"
            default:
                presetName = "default_sunset.mp4"
            }
            
            let fallbackURL = defaultDir.appendingPathComponent(presetName)
            if FileManager.default.fileExists(atPath: fallbackURL.path) {
                effectiveURL = fallbackURL
            } else {
                let firstFallback = defaultDir.appendingPathComponent("default_cyberpunk.mp4")
                if FileManager.default.fileExists(atPath: firstFallback.path) {
                    effectiveURL = firstFallback
                }
            }
        }
        
        guard FileManager.default.fileExists(atPath: effectiveURL.path) else {
            return
        }
        
        let asset = AVURLAsset(url: effectiveURL, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.preferredForwardBufferDuration = 3.0
        playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = false
        
        if crossfade {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.45
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.playerLayer.add(transition, forKey: "wallpaperCrossfade")
        }
        
        self.player.pause()
        self.player.removeAllItems()
        
        if loop {
            self.playerLooper = AVPlayerLooper(player: self.player, templateItem: playerItem)
        } else {
            self.playerLooper = nil
            self.player.insert(playerItem, after: nil)
        }
        
        self.player.play()
        self.isPlaying = true
    }
    
    public func loadVideo(url: URL, loop: Bool = true, crossfade: Bool = true) {
        let dummyItem = WallpaperItem(
            id: url.lastPathComponent,
            title: url.deletingPathExtension().lastPathComponent,
            category: .abstract,
            resolution: "4K",
            duration: 60.0,
            fileSize: "10MB",
            thumbnailURL: "",
            videoURL: url,
            author: "Local",
            likes: 1
        )
        loadWallpaper(dummyItem, loop: loop, crossfade: crossfade)
    }
    
    public func play() {
        self.player.play()
        self.isPlaying = true
    }
    
    public func pause() {
        self.player.pause()
        self.isPlaying = false
    }
    
    public func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    public func setMuted(_ muted: Bool) {
        self.isMuted = muted
        self.player.isMuted = muted
    }
    
    public func setVolume(_ val: Float) {
        self.volume = max(0.0, min(1.0, val))
        self.player.volume = self.volume
        if self.volume > 0 {
            self.isMuted = false
            self.player.isMuted = false
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlayerItemFailed(_:)),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: nil
        )
    }
    
    private func setupThermalObserver() {
        self.thermalObserver = NotificationCenter.default.addObserver(
            forName: ProcessInfo.thermalStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleThermalStateChange()
        }
    }
    
    private func handleThermalStateChange() {
        let state = ProcessInfo.processInfo.thermalState
        switch state {
        case .nominal, .fair:
            self.player.automaticallyWaitsToMinimizeStalling = false
        case .serious, .critical:
            self.player.automaticallyWaitsToMinimizeStalling = true
        @unknown default:
            break
        }
    }
    
    @objc private func handlePlayerItemFailed(_ notification: Notification) {
        if let error = (notification.object as? AVPlayerItem)?.error {
            print("[Wallep PlayerEngine] Notice: \(error.localizedDescription)")
        }
    }
}
