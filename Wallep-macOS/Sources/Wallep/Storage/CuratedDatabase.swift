import Foundation

public struct CuratedDatabase {
    public static let shared = CuratedDatabase()
    
    public struct Entry: Identifiable, Codable {
        public let id: String
        public let title: String
        public let category: WallpaperCategory
        public let resolution: String
        public let fps: Int
        public let author: String
        public let likes: Int
        public let tags: [String]
    }
    
    public let totalCount: Int = 5020
}
