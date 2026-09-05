import Foundation
import Combine

public enum SolarPhase: String, CaseIterable, Identifiable {
    case dawn = "Dawn (Soft Blue)"
    case sunrise = "Sunrise (Golden)"
    case midday = "Midday (Vibrant)"
    case goldenHour = "Golden Hour (Amber)"
    case dusk = "Dusk (Crimson Purple)"
    case midnight = "Midnight (Deep Dark)"
    
    public var id: String { rawValue }
}

public final class SolarTimeManager: ObservableObject {
    public static let shared = SolarTimeManager()
    
    @Published public var currentPhase: SolarPhase = .midday
    @Published public var isSolarAutoSyncEnabled: Bool = true
    
    private var timer: Timer?
    
    private init() {
        updateSolarPhase()
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateSolarPhase()
        }
    }
    
    public func updateSolarPhase() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<7: currentPhase = .dawn
        case 7..<10: currentPhase = .sunrise
        case 10..<16: currentPhase = .midday
        case 16..<19: currentPhase = .goldenHour
        case 19..<22: currentPhase = .dusk
        default: currentPhase = .midnight
        }
    }
}
