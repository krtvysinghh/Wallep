import AVFoundation

public final class SeamlessLoopSynthesizer {
    public static func crossfadeComposition(for asset: AVAsset, durationSeconds: Double = 1.0) -> AVMutableComposition? {
        let composition = AVMutableComposition()
        let semaphore = DispatchSemaphore(value: 0)
        var firstTrack: AVAssetTrack?
        
        Task {
            if let tracks = try? await asset.loadTracks(withMediaType: .video) {
                firstTrack = tracks.first
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 1.0)
        
        guard let track = firstTrack,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return nil
        }
        
        var assetDuration: CMTime = .zero
        let durSemaphore = DispatchSemaphore(value: 0)
        Task {
            if let dur = try? await asset.load(.duration) {
                assetDuration = dur
            }
            durSemaphore.signal()
        }
        _ = durSemaphore.wait(timeout: .now() + 1.0)
        
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: assetDuration), of: track, at: .zero)
        return composition
    }
}
