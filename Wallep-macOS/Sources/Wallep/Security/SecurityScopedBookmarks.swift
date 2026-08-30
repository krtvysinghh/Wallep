import Foundation

public final class SecurityScopedBookmarks {
    public static let shared = SecurityScopedBookmarks()
    
    private init() {}
    
    public func createBookmark(for url: URL) -> Data? {
        return try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
    }
    
    public func resolveBookmark(data: Data) -> URL? {
        var isStale = false
        return try? URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
    }
}
