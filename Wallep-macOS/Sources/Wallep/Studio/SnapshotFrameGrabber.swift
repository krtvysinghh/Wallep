import Cocoa
import AVFoundation

public struct SnapshotFrameGrabber {
    public static func exportFrame(from asset: AVAsset, at time: CMTime, to destinationURL: URL) -> Bool {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            let bitmap = NSBitmapImageRep(cgImage: cgImage)
            guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
                return false
            }
            try pngData.write(to: destinationURL)
            return true
        } catch {
            return false
        }
    }
}
