import AVFoundation

public final class LoopCrossfadeComposer {
    public static func composeSeamlessLoop(asset: AVAsset, crossfadeDuration: CMTime) -> AVMutableComposition? {
        let composition = AVMutableComposition()
        guard let videoTrack = asset.tracks(withMediaType: .video).first,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: videoTrack, at: .zero)
        return composition
    }
}
