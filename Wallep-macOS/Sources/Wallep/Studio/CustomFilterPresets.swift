import CoreImage

public struct StudioFilterPreset {
    public let name: String
    public let brightness: Float
    public let contrast: Float
    public let saturation: Float
    
    public static let presets: [StudioFilterPreset] = [
        StudioFilterPreset(name: "Vibrant HDR", brightness: 0.05, contrast: 1.15, saturation: 1.35),
        StudioFilterPreset(name: "Cyberpunk Neon", brightness: -0.05, contrast: 1.30, saturation: 1.60),
        StudioFilterPreset(name: "Golden Sunset", brightness: 0.10, contrast: 1.05, saturation: 1.20),
        StudioFilterPreset(name: "Midnight Noir", brightness: -0.15, contrast: 1.40, saturation: 0.00),
        StudioFilterPreset(name: "Emerald Forest", brightness: 0.00, contrast: 1.10, saturation: 1.45)
    ]
}
