import Cocoa
import AVFoundation

public final class SoundtrackManager: ObservableObject {
    public static let shared = SoundtrackManager()
    
    private var audioPlayer: AVAudioPlayer?
    @Published public var isAmbientPlaying: Bool = false
    @Published public var ambientVolume: Float = 0.25
    @Published public var currentSoundscape: String = "Rain on Glass"
    
    private init() {}
    
    public func playAmbient(named: String) {
        currentSoundscape = named
        isAmbientPlaying = true
    }
    
    public func stopAmbient() {
        audioPlayer?.stop()
        isAmbientPlaying = false
    }
}
