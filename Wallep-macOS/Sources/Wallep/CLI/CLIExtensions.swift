import Foundation

public struct CLIExtensions {
    public static func handleExtended(cmd: String, args: [String]) -> Bool {
        switch cmd {
        case "diagnostics":
            print(SystemDiagnostics.diagnosticSummary())
            return true
        case "playlists":
            for pl in PlaylistManager.shared.playlists {
                print("• \(pl.name) (\(pl.wallpaperIDs.count) wallpapers)")
            }
            return true
        default:
            return false
        }
    }
}
