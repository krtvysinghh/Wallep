import Foundation
import Combine

public struct WallpaperPlaylist: Identifiable, Codable, Equatable {
    public let id: String
    public var name: String
    public var wallpaperIDs: [String]
    public var createdAt: Date
    
    public init(id: String = UUID().uuidString, name: String, wallpaperIDs: [String] = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.wallpaperIDs = wallpaperIDs
        self.createdAt = createdAt
    }
}

public final class PlaylistManager: ObservableObject {
    public static let shared = PlaylistManager()
    
    @Published public var playlists: [WallpaperPlaylist] = []
    
    private init() {
        self.playlists = [
            WallpaperPlaylist(name: "Favorites", wallpaperIDs: ["default_cyberpunk", "default_aurora"]),
            WallpaperPlaylist(name: "Midnight Focus", wallpaperIDs: ["default_nebula", "default_sunset"])
        ]
    }
    
    public func createPlaylist(name: String) -> WallpaperPlaylist {
        let pl = WallpaperPlaylist(name: name)
        playlists.append(pl)
        return pl
    }
    
    public func deletePlaylist(id: String) {
        playlists.removeAll(where: { $0.id == id })
    }
}
