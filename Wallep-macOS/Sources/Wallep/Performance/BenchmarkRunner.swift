import Foundation
import QuartzCore

public final class BenchmarkRunner {
    public static func measureFrameTiming(iterations: Int = 100, block: () -> Void) -> Double {
        let start = CACurrentMediaTime()
        for _ in 0..<iterations {
            block()
        }
        let end = CACurrentMediaTime()
        return (end - start) / Double(iterations) * 1000.0 // ms per iteration
    }
}
