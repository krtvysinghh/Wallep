import CoreImage
import Cocoa

public enum ColorGradingPreset: String, CaseIterable, Identifiable {
    case original = "Original"
    case vibrant = "Vibrant Boost"
    case cinematic = "Cinematic 35mm"
    case noir = "Film Noir"
    case cyberpunk = "Neon Cyberpunk"
    case goldenHour = "Golden Hour"
    case vaporwave = "Vaporwave Pastel"
    
    public var id: String { rawValue }
}

public final class ColorGradingEngine {
    public static let shared = ColorGradingEngine()
    
    private init() {}
    
    public func filter(for preset: ColorGradingPreset) -> CIFilter? {
        switch preset {
        case .original:
            return nil
        case .vibrant:
            return CIFilter(name: "CIColorControls", parameters: [kCIInputSaturationKey: 1.4, kCIInputContrastKey: 1.1])
        case .cinematic:
            return CIFilter(name: "CIPhotoEffectProcess")
        case .noir:
            return CIFilter(name: "CIPhotoEffectNoir")
        case .cyberpunk:
            return CIFilter(name: "CIColorMatrix")
        case .goldenHour:
            return CIFilter(name: "CITemperatureAndTint", parameters: ["inputNeutral": CIVector(x: 6500, y: 0), "inputTargetNeutral": CIVector(x: 5200, y: 0)])
        case .vaporwave:
            return CIFilter(name: "CIHueAdjust", parameters: [kCIInputAngleKey: 0.8])
        }
    }
}
