import Cocoa

public struct DynamicResolutionScaler {
    public static func optimalBufferSize(for screen: NSScreen) -> CGSize {
        let scale = screen.backingScaleFactor
        return CGSize(width: screen.frame.width * scale, height: screen.frame.height * scale)
    }
}
