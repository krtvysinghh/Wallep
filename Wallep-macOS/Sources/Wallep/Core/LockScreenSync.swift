import Cocoa
import AVFoundation

public final class LockScreenSync: ObservableObject {
    public static let shared = LockScreenSync()
    
    @Published public var isLockScreenSyncEnabled: Bool = true
    @Published public var isScreensaverSyncEnabled: Bool = true
    
    private init() {}
    
    public func exportStillFrame(from videoURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 3840, height: 2160)
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let rep = NSBitmapImageRep(cgImage: cgImage)
                guard let data = rep.representation(using: .jpeg, properties: [:]) else {
                    completion(nil)
                    return
                }
                
                let cacheDir = FileManager.default.temporaryDirectory
                let targetURL = cacheDir.appendingPathComponent("wallep_lockscreen_frame.jpg")
                try data.write(to: targetURL)
                
                DispatchQueue.main.async {
                    completion(targetURL)
                }
            } catch {
                print("Failed to capture lock screen frame: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
