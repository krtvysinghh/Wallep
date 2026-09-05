import AVFoundation
import Combine

public final class SpatialSoundscapeMixer: ObservableObject {
    public static let shared = SpatialSoundscapeMixer()
    
    @Published public var rainVolume: Double = 0.4
    @Published public var thunderVolume: Double = 0.0
    @Published public var forestVolume: Double = 0.2
    @Published public var campfireVolume: Double = 0.0
    @Published public var oceanVolume: Double = 0.0
    @Published public var loFiVinylVolume: Double = 0.3
    
    @Published public var isMasterEnabled: Bool = true
    
    public init() {}
    
    public func setMasterMuted(_ muted: Bool) {
        self.isMasterEnabled = !muted
    }
}
