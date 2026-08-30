import Foundation

public final class PlaylistPersistenceController {
    public static let shared = PlaylistPersistenceController()
    
    private init() {}
    
    public func exportPlaylists(_ playlists: [WallpaperPlaylist], to url: URL) throws {
        let data = try JSONEncoder().encode(playlists)
        try data.write(to: url)
    }
    
    public func importPlaylists(from url: URL) throws -> [WallpaperPlaylist] {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([WallpaperPlaylist].self, from: data)
    }
}
