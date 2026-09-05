import Cocoa
import Combine

public final class NowPlayingTintEngine: ObservableObject {
    public static let shared = NowPlayingTintEngine()
    
    @Published public var isNowPlayingSyncEnabled: Bool = false
    @Published public var currentTrackTitle: String = ""
    @Published public var currentArtist: String = ""
    @Published public var dominantTint: NSColor = NSColor(calibratedRed: 0.4, green: 0.2, blue: 0.8, alpha: 1.0)
    
    private init() {}
    
    public func updateTrackInfo(title: String, artist: String, albumHue: Double) {
        self.currentTrackTitle = title
        self.currentArtist = artist
        self.dominantTint = NSColor(calibratedHue: CGFloat(albumHue), saturation: 0.8, brightness: 0.9, alpha: 1.0)
    }
}
