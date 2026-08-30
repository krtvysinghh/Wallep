import Cocoa

public final class LRUThumbnailMemoryCache {
    public static let shared = LRUThumbnailMemoryCache()
    private let cache = NSCache<NSString, NSImage>()
    
    private init() {
        cache.totalCostLimit = 100 * 1024 * 1024 // 100MB
    }
    
    public func clear() {
        cache.removeAllObjects()
    }
}
