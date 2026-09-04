import Foundation

public struct CLIBattery {
    public static func printStatus() {
        print("Wallep Energy Governor Status:")
        print("  • Thermal Rating: \(ThermalStateGovernor.shared.currentThermalRating())")
        print("  • Estimated Power: \(PowerMetricsCollector.estimatedPowerUsageWatts())W")
    }
}
