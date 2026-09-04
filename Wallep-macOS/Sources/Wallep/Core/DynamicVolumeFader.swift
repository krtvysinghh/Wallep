import Foundation

public final class DynamicVolumeFader {
    public static func fade(from: Float, to: Float, duration: TimeInterval = 0.5, step: @escaping (Float) -> Void) {
        step(to)
    }
}
