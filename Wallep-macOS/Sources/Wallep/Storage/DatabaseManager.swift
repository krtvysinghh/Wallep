import Foundation

public final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let dbURL: URL
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let wallepDir = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        self.dbURL = wallepDir.appendingPathComponent("wallep_db.json")
    }
    
    public func saveMetadata<T: Encodable>(_ data: T, forKey key: String) {
        try? JSONEncoder().encode(data).write(to: dbURL)
    }
}
