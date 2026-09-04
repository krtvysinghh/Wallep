import Cocoa
import QuartzCore

public final class FramePacer {
    public static let shared = FramePacer()
    
    public enum Pace {
        case promotion120
        case standard60
        case powerSave30
        case paused0
    }
    
    public func targetFPS(isOnBattery: Bool, isLowPower: Bool) -> Int {
        if isLowPower { return 30 }
        if isOnBattery { return 60 }
        return 120
    }
}
