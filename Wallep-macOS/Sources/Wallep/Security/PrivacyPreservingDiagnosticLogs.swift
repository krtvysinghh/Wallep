import Foundation

public final class PrivacyPreservingDiagnosticLogs {
    public static func sanitizeLogString(_ raw: String) -> String {
        let username = NSUserName()
        var sanitized = raw.replacingOccurrences(of: NSHomeDirectory(), with: "~")
                           .replacingOccurrences(of: username, with: "user_redacted")
        
        // Regex sanitize any /Users/<user> path
        if let regex = try? NSRegularExpression(pattern: "/Users/[a-zA-Z0-9._-]+", options: []) {
            let range = NSRange(location: 0, length: sanitized.utf16.count)
            sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "~")
        }
        return sanitized
    }
}
