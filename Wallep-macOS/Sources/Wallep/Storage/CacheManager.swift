import Foundation
import Cocoa

public final class CacheManager {
    public static let shared = CacheManager()
    
    private init() {}
    
    public func pruneCache(maxAgeDays: Int = 30) {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        
        let files = (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: [.contentModificationDateKey])) ?? []
        let threshold = Date().addingTimeInterval(-Double(maxAgeDays * 86400))
        
        for file in files where file.pathExtension == "jpg" {
            if let date = (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate, date < threshold {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }
}
