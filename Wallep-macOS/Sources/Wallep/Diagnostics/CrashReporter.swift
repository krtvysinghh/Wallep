import Foundation

public final class CrashReporter {
    public static func logDiagnosticEvent(_ message: String) {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let logURL = appSupport.appendingPathComponent("Wallep/wallep_diagnostics.log")
        let entry = "[\(Date())] \(message)\n"
        if let data = entry.data(using: .utf8) {
            if let handle = try? FileHandle(forWritingTo: logURL) {
                handle.seekToEndOfFile()
                handle.write(data)
                try? handle.close()
            } else {
                try? data.write(to: logURL)
            }
        }
    }
}
