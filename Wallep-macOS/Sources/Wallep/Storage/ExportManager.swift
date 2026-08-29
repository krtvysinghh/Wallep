import Foundation
import Cocoa

public final class ExportManager {
    public static let shared = ExportManager()
    
    private init() {}
    
    public func exportWallpaperPackage(item: WallpaperItem, destination: URL) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: item.videoURL.path) {
            try fileManager.copyItem(at: item.videoURL, to: destination)
        }
    }
}
