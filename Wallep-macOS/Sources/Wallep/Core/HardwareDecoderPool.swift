import Foundation
import VideoToolbox

public final class HardwareDecoderPool {
    public static let shared = HardwareDecoderPool()
    
    private init() {}
    
    public func isHardwareDecodingSupported() -> Bool {
        return VTIsHardwareDecodeSupported(kCMVideoCodecType_H264)
    }
}
