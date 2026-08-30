import Foundation

public final class PrivacyPreservingDiagnosticLogs {
    public static func sanitizeLogString(_ raw: String) -> String {
        let username = NSUserName()
        return raw.replacingOccurrences(of: username, with: "user_redacted")
                  .replacingOccurrences(of: NSHomeDirectory(), with: "~")
    }
}
