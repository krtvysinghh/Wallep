import Cocoa
import AVFoundation

public final class PlayerEngine: NSObject, ObservableObject {
    public let player: AVQueuePlayer
    private var playerLooper: AVPlayerLooper?
    public let playerLayer: AVPlayerLayer
    public let containerView: NSView
    
    @Published public var isPlaying: Bool = false
    @Published public var isMuted: Bool = true
    @Published public var volume: Float = 0.0
    @Published public var currentURL: URL?
    
    public init(screenBounds: NSRect) {
        self.player = AVQueuePlayer()
        self.player.isMuted = true
        self.player.volume = 0.0
        self.player.automaticallyWaitsToMinimizeStalling = false
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.frame = screenBounds
        
        self.containerView = NSView(frame: screenBounds)
        self.containerView.wantsLayer = true
        self.containerView.layer = CALayer()
        self.containerView.layer?.backgroundColor = NSColor.black.cgColor
        self.containerView.layer?.addSublayer(self.playerLayer)
        
        super.init()
        
        setupNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    public func loadVideo(url: URL, loop: Bool = true, crossfade: Bool = true) {
        self.currentURL = url
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
        
        let playerItem = AVPlayerItem(asset: asset)
        
        if crossfade {
            // Animate layer opacity for silky smooth wallpaper transitions
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.5
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
    
    @objc private func handlePlayerItemFailed(_ notification: Notification) {
        if let error = (notification.object as? AVPlayerItem)?.error {
            print("[Wallep PlayerEngine] Playback error: \(error.localizedDescription)")
        }
    }
}
