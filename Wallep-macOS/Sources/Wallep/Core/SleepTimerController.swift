import Foundation

public final class SleepTimerController: ObservableObject {
    public static let shared = SleepTimerController()
    @Published public var remainingMinutes: Int = 0
    private var timer: Timer?
    
    public func setTimer(minutes: Int) {
        self.remainingMinutes = minutes
    }
}
