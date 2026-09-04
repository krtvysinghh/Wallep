import Foundation

public final class CatalogSearchIndex {
    public static let shared = CatalogSearchIndex()
    private var tokenIndex: [String: Set<String>] = [:]
    
    private init() {}
    
    public func index(items: [WallpaperItem]) {
        tokenIndex.removeAll()
        for item in items {
            let tokens = (item.title + " " + item.author + " " + item.category.rawValue).lowercased().components(separatedBy: .whitespacesAndNewlines)
            for token in tokens where !token.isEmpty {
                tokenIndex[token, default: []].insert(item.id)
            }
        }
    }
    
    public func search(query: String) -> Set<String> {
        let q = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return tokenIndex[q] ?? []
    }
}
