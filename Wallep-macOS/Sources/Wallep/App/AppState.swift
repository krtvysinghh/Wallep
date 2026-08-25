import SwiftUI
import Combine

public enum ActiveTab: String, CaseIterable, Identifiable {
    case gallery = "Gallery"
    case studio = "Studio"
    case settings = "Settings"
    
    public var id: String { rawValue }
}

public final class AppState: ObservableObject {
    public static let shared = AppState()
    
    @Published public var activeTab: ActiveTab = .gallery
    @Published public var isGalleryWindowOpen: Bool = false
    @Published public var isMuted: Bool = true
    @Published public var volume: Double = 0.0
    @Published public var launchAtLogin: Bool = true
    @Published public var autoPauseOnBattery: Bool = true
    @Published public var autoPauseOnFullScreen: Bool = true
    
    public let wallpaperManager = WallpaperManager.shared
    public let libraryManager = LibraryManager.shared
    public let powerManager = PowerManager.shared
    public let studio = WallpaperStudio.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Set initial sample wallpaper if available
        if let first = libraryManager.wallpapers.first {
            wallpaperManager.setWallpaper(first)
        }
        
        // Sync audio settings
        $isMuted
            .sink { [weak self] muted in
                self?.wallpaperManager.setMuted(muted)
            }
            .store(in: &cancellables)
            
        $volume
            .sink { [weak self] vol in
                self?.wallpaperManager.setVolume(Float(vol))
            }
            .store(in: &cancellables)
            
        $autoPauseOnBattery
            .sink { [weak self] pause in
                self?.powerManager.pauseOnBattery = pause
            }
            .store(in: &cancellables)
            
        $autoPauseOnFullScreen
            .sink { [weak self] pause in
                self?.powerManager.pauseOnFullScreen = pause
            }
            .store(in: &cancellables)
    }
    
    public func selectWallpaper(_ wallpaper: WallpaperItem) {
        wallpaperManager.setWallpaper(wallpaper)
    }
    
    public func togglePlayback() {
        wallpaperManager.togglePlayPause()
    }
}
