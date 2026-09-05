import SwiftUI
import Combine

public enum ClockStyle: String, CaseIterable, Identifiable {
    case modernDigital = "Modern Digital"
    case minimalistAnalog = "Minimalist Analog"
    case tokyoKanji = "Tokyo Cyber Kanji"
    case retroFlip = "Retro Flip Clock"
    
    public var id: String { rawValue }
}

public final class DesktopWidgetManager: ObservableObject {
    public static let shared = DesktopWidgetManager()
    
    // Toggles
    @Published public var showClock: Bool = true
    @Published public var clockStyle: ClockStyle = .modernDigital
    @Published public var showSystemMonitor: Bool = true
    @Published public var showWeather: Bool = true
    @Published public var showDailyQuote: Bool = true
    @Published public var showAudioVisualizer: Bool = false
    @Published public var showGitHubGraph: Bool = false
    
    // Styling & Positioning
    @Published public var widgetOpacity: Double = 0.85
    @Published public var widgetScale: Double = 1.0
    @Published public var clockAlignment: Alignment = .topLeading
    
    // Live Telemetry
    @Published public var cpuUsage: Double = 3.2
    @Published public var memoryUsage: Double = 4.8
    @Published public var batteryPercent: Int = 100
    @Published public var currentTemp: String = "22°C"
    @Published public var weatherCondition: String = "Clear Sky"
    @Published public var dailyQuote: String = "Creativity is intelligence having fun."
    @Published public var quoteAuthor: String = "Albert Einstein"
    
    private var telemetryTimer: Timer?
    
    private init() {
        startTelemetryLoop()
    }
    
    private func startTelemetryLoop() {
        telemetryTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateTelemetry()
        }
    }
    
    private func updateTelemetry() {
        // Calculate simulated live CPU and RAM
        let thermal = ProcessInfo.processInfo.thermalState
        let baseCpu = (thermal == .nominal) ? 2.5 : 8.0
        self.cpuUsage = max(1.0, min(100.0, baseCpu + Double.random(in: -0.8...1.5)))
        self.memoryUsage = 5.2 + Double.random(in: -0.2...0.3)
    }
}
