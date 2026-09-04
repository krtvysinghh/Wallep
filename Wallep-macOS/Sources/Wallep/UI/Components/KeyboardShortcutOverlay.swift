import SwiftUI

public struct KeyboardShortcutOverlay: View {
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("⌥⌘N : Next Wallpaper").font(.caption)
            Text("⌥⌘Space : Play / Pause").font(.caption)
        }
    }
}
