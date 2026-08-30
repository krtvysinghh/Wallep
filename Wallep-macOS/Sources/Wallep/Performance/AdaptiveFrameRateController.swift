import Cocoa

public final class AdaptiveFrameRateController {
    public static let shared = AdaptiveFrameRateController()
    
    private init() {}
    
    public func targetFrameRate(for screen: NSScreen) -> Int {
        let maxRate = screen.maximumExtendedDynamicRangeColorComponentValue
        return maxRate > 1.0 ? 120 : 60
    }
}
