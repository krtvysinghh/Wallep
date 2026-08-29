import Foundation
import Combine

public final class HistoryManager: ObservableObject {
    public static let shared = HistoryManager()
    
    @Published public private(set) var history: [WallpaperItem] = []
    private let maxHistory = 50
    
    private init() {}
    
    public func record(item: WallpaperItem) {
        history.removeAll(where: { $0.id == item.id })
        history.insert(item, at: 0)
        if history.count > maxHistory {
            history = Array(history.prefix(maxHistory))
        }
    }
    
    public func clear() {
        history.removeAll()
    }
}
