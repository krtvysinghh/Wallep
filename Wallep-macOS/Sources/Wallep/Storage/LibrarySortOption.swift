import Foundation

public enum LibrarySortOption: String, CaseIterable, Identifiable {
    case trending = "Trending (Most Liked)"
    case newest = "Newest"
    case duration = "Duration (Longest)"
    case resolution = "Resolution (5K/4K)"
    
    public var id: String { rawValue }
}
