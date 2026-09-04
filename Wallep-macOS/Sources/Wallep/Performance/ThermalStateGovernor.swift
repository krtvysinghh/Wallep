import Foundation

public final class ThermalStateGovernor {
    public static let shared = ThermalStateGovernor()
    
    public func currentThermalRating() -> String {
        switch ProcessInfo.processInfo.thermalState {
        case .nominal: return "Nominal (Cool)"
        case .fair: return "Fair"
        case .serious: return "Serious (Throttled)"
        case .critical: return "Critical (Power Save)"
        @unknown default: return "Optimal"
        }
    }
}
