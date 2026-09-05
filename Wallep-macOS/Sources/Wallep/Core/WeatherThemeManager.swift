import Foundation
import Combine

public enum WeatherCondition: String, CaseIterable, Identifiable {
    case clear = "Clear Sky"
    case cloudy = "Overcast Clouds"
    case rain = "Atmospheric Rain"
    case thunderstorm = "Thunderstorm"
    case snow = "Winter Snow"
    case fog = "Misty Fog"
    
    public var id: String { rawValue }
}

public final class WeatherThemeManager: ObservableObject {
    public static let shared = WeatherThemeManager()
    
    @Published public var currentCondition: WeatherCondition = .clear
    @Published public var isWeatherSyncEnabled: Bool = true
    @Published public var simulatedTempCelsius: Int = 22
    
    private var updateTimer: Timer?
    
    private init() {
        startWeatherMonitoring()
    }
    
    public func startWeatherMonitoring() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { [weak self] _ in
            self?.refreshWeather()
        }
    }
    
    public func refreshWeather() {
        // Adaptively cycles or matches simulated weather
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 20 || hour < 5 {
            self.currentCondition = .clear
            self.simulatedTempCelsius = 16
        } else {
            self.simulatedTempCelsius = 22
        }
    }
}
