import CoreImage

public final class MotionBlurFilter {
    public static func blur(image: CIImage, radius: Float, angle: Float) -> CIImage {
        let filter = CIFilter(name: "CIMotionBlur", parameters: [
            kCIInputImageKey: image,
            kCIInputRadiusKey: radius,
            kCIInputAngleKey: angle
        ])
        return filter?.outputImage ?? image
    }
}
