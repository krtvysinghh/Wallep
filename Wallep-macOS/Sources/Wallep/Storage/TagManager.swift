import Foundation

public final class TagManager {
    public static let shared = TagManager()
    
    private init() {}
    
    public func tags(for item: WallpaperItem) -> [String] {
        var tags = [item.category.rawValue, item.resolution]
        if item.isFavorite { tags.append("Favorite") }
        if item.isCustom { tags.append("Custom Import") }
        return tags
    }
}
