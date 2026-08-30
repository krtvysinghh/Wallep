import AVFoundation

public final class WallpaperLoopSync {
    public static let shared = WallpaperLoopSync()
    
    private init() {}
    
    public func synchronizeDisplays(players: [AVQueuePlayer]) {
        let masterTime = CMTime(seconds: 0, preferredTimescale: 600)
        for player in players {
            player.seek(to: masterTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
}
