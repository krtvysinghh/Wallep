import AVFoundation

public final class SeamlessLoopSynthesizer {
    public static func crossfadeComposition(for asset: AVAsset, durationSeconds: Double = 1.0) -> AVMutableComposition? {
        let composition = AVMutableComposition()
        guard let track = asset.tracks(withMediaType: .video).first,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: track, at: .zero)
        return composition
    }
}
