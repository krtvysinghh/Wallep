import Foundation
import Combine

public final class AudioVisualizerEngine: ObservableObject {
    public static let shared = AudioVisualizerEngine()
    
    @Published public var frequencyBands: [Float] = Array(repeating: 0.1, count: 16)
    @Published public var isVisualizerActive: Bool = false
    
    private var timer: Timer?
    
    private init() {}
    
    public func start() {
        isVisualizerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.frequencyBands = (0..<16).map { _ in Float.random(in: 0.1...0.95) }
        }
    }
    
    public func stop() {
        isVisualizerActive = false
        timer?.invalidate()
        timer = nil
        frequencyBands = Array(repeating: 0.0, count: 16)
    }
}
