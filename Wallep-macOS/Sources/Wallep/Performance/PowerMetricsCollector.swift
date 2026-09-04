import Foundation

public struct PowerMetricsCollector {
    public static func estimatedPowerUsageWatts() -> Double {
        return EnergyGovernor.shared.shouldThrottle ? 0.05 : 0.45
    }
}
