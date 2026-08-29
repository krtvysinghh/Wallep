import Foundation

public final class SandboxValidator {
    public static func validateApplicationSupportDirectory() -> Bool {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let wallepDir = appSupport.appendingPathComponent("Wallep", isDirectory: true)
        return FileManager.default.isWritableFile(atPath: wallepDir.path) || ((try? FileManager.default.createDirectory(at: wallepDir, withIntermediateDirectories: true)) != nil)
    }
}
