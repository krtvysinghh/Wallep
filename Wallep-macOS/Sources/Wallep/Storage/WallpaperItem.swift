import Foundation

public enum WallpaperCategory: String, CaseIterable, Codable, Identifiable {
    case all = "All"
    case nature = "Nature"
    case anime = "Anime"
    case cyberpunk = "Cyberpunk"
    case cars = "Cars"
    case minimalist = "Minimalist"
    case space = "Space"
    case abstract = "Abstract"
    
    public var id: String { rawValue }
}

public struct WallpaperItem: Identifiable, Codable, Equatable {
    public let id: String
    public var title: String
    public var category: WallpaperCategory
    public var resolution: String
    public var duration: TimeInterval
    public var fileSize: String
    public var thumbnailURL: String
    public var videoURL: URL
    public var author: String
    public var likes: Int
    public var isFavorite: Bool
    public var isCustom: Bool
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        category: WallpaperCategory,
        resolution: String = "3840x2160 (4K)",
        duration: TimeInterval = 60.0,
        fileSize: String = "35MB",
        thumbnailURL: String = "",
        videoURL: URL,
        author: String = "Wallep Studio",
        likes: Int = 120,
        isFavorite: Bool = false,
        isCustom: Bool = false
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.resolution = resolution
        self.duration = duration
        self.fileSize = fileSize
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.author = author
        self.likes = likes
        self.isFavorite = isFavorite
        self.isCustom = isCustom
    }
}
