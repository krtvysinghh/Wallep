import Foundation

public final class EnergyGovernor {
    public static let shared = EnergyGovernor()
    
    public var shouldThrottle: Bool {
        return PowerManager.shared.isOnBattery && PowerManager.shared.pauseOnBattery
    }
}
