import Foundation

public final class VideoIntegrityValidator {
    public static func checkIntegrity(fileURL: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return false }
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let size = attrs[.size] as? Int64, size > 1024 else { return false }
        return MIMEValidator.validateVideoFile(at: fileURL)
    }
}
