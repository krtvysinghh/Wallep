import CoreImage

public final class VignetteAndFilmGrainFilter {
    public static func apply(to image: CIImage, intensity: Float) -> CIImage {
        let filter = CIFilter(name: "CIVignette", parameters: [
            kCIInputImageKey: image,
            kCIInputIntensityKey: intensity,
            kCIInputRadiusKey: 1.5
        ])
        return filter?.outputImage ?? image
    }
}
