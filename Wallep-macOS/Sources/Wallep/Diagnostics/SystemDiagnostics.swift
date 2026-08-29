import Cocoa
import Metal

public final class SystemDiagnostics {
    public static func diagnosticSummary() -> String {
        let metal = MTLCreateSystemDefaultDevice()?.name ?? "No Metal GPU"
        let screens = NSScreen.screens.map { "\($0.frame.width)x\($0.frame.height)" }.joined(separator: ", ")
        let thermal = ProcessInfo.processInfo.thermalState
        return "GPU: \(metal) | Displays: \(screens) | Thermal: \(thermal.rawValue)"
    }
}
