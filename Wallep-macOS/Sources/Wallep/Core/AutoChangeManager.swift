import SwiftUI
import Cocoa

public enum AutoChangeInterval: String, CaseIterable, Identifiable, Codable {
    case oneMinute = "Every 1 minute (Demo)"
    case fiveMinutes = "Every 5 minutes"
    case fifteenMinutes = "Every 15 minutes"
    case thirtyMinutes = "Every 30 minutes"
    case oneHour = "Every 1 hour"
    case sixHours = "Every 6 hours"
    case daily = "Every 24 hours (Daily)"
    
    public var id: String { rawValue }
    
    public var timeInterval: TimeInterval {
        switch self {
        case .oneMinute: return 60
        case .fiveMinutes: return 300
        case .fifteenMinutes: return 900
        case .thirtyMinutes: return 1800
        case .oneHour: return 3600
        case .sixHours: return 21600
        case .daily: return 86400
        }
    }
}

public enum AutoChangeSource: String, CaseIterable, Identifiable, Codable {
    case all = "Entire Library (5,000+)"
    case currentCategory = "Current Category"
    case favoritesOnly = "Favorites Only"
    
    public var id: String { rawValue }
}

public final class AutoChangeManager: ObservableObject {
    public static let shared = AutoChangeManager()
    
    @Published public var isEnabled: Bool = false {
        didSet { restartTimer() }
    }
    @Published public var interval: AutoChangeInterval = .fifteenMinutes {
        didSet { restartTimer() }
    }
    @Published public var source: AutoChangeSource = .all
    @Published public var isShuffle: Bool = true
    @Published public var changeOnWake: Bool = true
    @Published public var nextChangeDate: Date?
    @Published public var timeRemainingString: String = ""
    
    private var timer: Timer?
    private var countdownTimer: Timer?
    
    private init() {
        setupWakeObserver()
    }
    
    deinit {
        timer?.invalidate()
        countdownTimer?.invalidate()
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    public func toggle() {
        isEnabled.toggle()
    }
    
    public func triggerNextWallpaper() {
        let library = LibraryManager.shared
        let candidatePool: [WallpaperItem]
        
        switch source {
        case .all:
            candidatePool = library.wallpapers
        case .currentCategory:
            candidatePool = library.wallpapers.filter { $0.category == library.selectedCategory }
        case .favoritesOnly:
            let favs = library.wallpapers.filter { $0.isFavorite }
            candidatePool = favs.isEmpty ? library.wallpapers : favs
        }
        
        guard !candidatePool.isEmpty else { return }
        
        let nextItem: WallpaperItem
        let currentID = WallpaperManager.shared.currentWallpaper?.id
        
        if isShuffle {
            let available = candidatePool.filter { $0.id != currentID }
            nextItem = available.randomElement() ?? candidatePool[0]
        } else {
            if let currentID = currentID,
               let currentIndex = candidatePool.firstIndex(where: { $0.id == currentID }) {
                let nextIndex = (currentIndex + 1) % candidatePool.count
                nextItem = candidatePool[nextIndex]
            } else {
                nextItem = candidatePool[0]
            }
        }
        
        DispatchQueue.main.async {
            WallpaperManager.shared.setWallpaper(nextItem)
            self.updateNextChangeTimestamp()
        }
    }
    
    private func restartTimer() {
        timer?.invalidate()
        countdownTimer?.invalidate()
        
        guard isEnabled else {
            nextChangeDate = nil
            timeRemainingString = ""
            return
        }
        
        updateNextChangeTimestamp()
        
        timer = Timer.scheduledTimer(withTimeInterval: interval.timeInterval, repeats: true) { [weak self] _ in
            self?.triggerNextWallpaper()
        }
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateNextChangeTimestamp() {
        nextChangeDate = Date().addingTimeInterval(interval.timeInterval)
        updateCountdown()
    }
    
    private func updateCountdown() {
        guard let target = nextChangeDate, isEnabled else {
            timeRemainingString = ""
            return
        }
        let diff = Int(target.timeIntervalSinceNow)
        if diff <= 0 {
            timeRemainingString = "Changing..."
        } else {
            let mins = diff / 60
            let secs = diff % 60
            if mins > 0 {
                timeRemainingString = "\(mins)m \(secs)s"
            } else {
                timeRemainingString = "\(secs)s"
            }
        }
    }
    
    private func setupWakeObserver() {
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self, self.isEnabled && self.changeOnWake else { return }
            self.triggerNextWallpaper()
        }
    }
}
