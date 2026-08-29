import SwiftUI

public struct AccessibilityHelper {
    public static func applyWallpaperCardTraits<V: View>(_ view: V, title: String, resolution: String) -> some View {
        view
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title), \(resolution) Live Wallpaper")
            .accessibilityAddTraits(.isButton)
    }
}
