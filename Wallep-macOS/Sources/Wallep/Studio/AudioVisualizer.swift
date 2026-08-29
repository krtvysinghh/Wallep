import Cocoa
import CoreGraphics

public final class AudioVisualizer {
    public static let shared = AudioVisualizer()
    
    private init() {}
    
    public func generateWaveform(sampleCount: Int = 64) -> [CGFloat] {
        return (0..<sampleCount).map { _ in CGFloat.random(in: 0.1...0.9) }
    }
}
