import Cocoa
import Carbon

public final class KeyboardShortcutsManager {
    public static let shared = KeyboardShortcutsManager()
    
    private init() {}
    
    public func registerGlobalShortcuts() {
        // Registers local event monitors for application-wide quick keys
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains([.command, .option]) {
                switch event.charactersIgnoringModifiers?.lowercased() {
                case "n":
                    AutoChangeManager.shared.triggerNextWallpaper()
                    return nil
                case " ":
                    AppState.shared.togglePlayback()
                    return nil
                case "m":
                    AppState.shared.isMuted.toggle()
                    return nil
                default:
                    break
                }
            }
            return event
        }
    }
}
