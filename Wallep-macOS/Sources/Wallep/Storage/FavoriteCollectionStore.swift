import Foundation

public final class FavoriteCollectionStore {
    public static let shared = FavoriteCollectionStore()
    private let storeURL: URL
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        self.storeURL = dir.appendingPathComponent("favorites.json")
    }
    
    public func loadFavorites() -> Set<String> {
        guard let data = try? Data(contentsOf: storeURL),
              let list = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return Set(list)
    }
    
    public func saveFavorites(_ favorites: Set<String>) {
        let array = Array(favorites)
        if let data = try? JSONEncoder().encode(array) {
            try? data.write(to: storeURL)
        }
    }
}
