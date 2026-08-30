import AVFoundation
import Cocoa

public final class AmbientAudioMixer: ObservableObject {
    public static let shared = AmbientAudioMixer()
    
    @Published public var masterVolume: Float = 0.5
    @Published public var rainIntensity: Float = 0.3
    @Published public var windIntensity: Float = 0.2
    
    private init() {}
    
    public func setVolume(rain: Float, wind: Float) {
        self.rainIntensity = max(0.0, min(1.0, rain))
        self.windIntensity = max(0.0, min(1.0, wind))
    }
}
