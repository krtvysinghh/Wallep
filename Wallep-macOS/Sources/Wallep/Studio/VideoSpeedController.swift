import AVFoundation

public final class VideoSpeedController {
    public static func scaleSpeed(asset: AVAsset, rate: Float) -> AVMutableComposition? {
        guard rate > 0 else { return nil }
        let composition = AVMutableComposition()
        guard let videoTrack = asset.tracks(withMediaType: .video).first,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        
        let duration = asset.duration
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: videoTrack, at: .zero)
        let scaledDuration = CMTimeMultiplyByFloat64(duration, multiplier: 1.0 / Float64(rate))
        compTrack.scaleTimeRange(CMTimeRange(start: .zero, duration: duration), toDuration: scaledDuration)
        return composition
    }
}
