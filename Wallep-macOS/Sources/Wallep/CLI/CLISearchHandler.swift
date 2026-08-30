import Foundation

public struct CLISearchHandler {
    public static func search(query: String) {
        let matches = LibraryManager.shared.wallpapers.filter {
            $0.title.localizedCaseInsensitiveContains(query) || $0.category.rawValue.localizedCaseInsensitiveContains(query)
        }
        print("Found \(matches.count) matching wallpapers for '\(query)':")
        for item in matches.prefix(20) {
            print("  • [\(item.id)] \(item.title) (\(item.category.rawValue))")
        }
    }
}
