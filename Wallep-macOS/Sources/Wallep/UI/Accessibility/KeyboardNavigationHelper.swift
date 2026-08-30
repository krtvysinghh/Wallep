import SwiftUI

public struct KeyboardNavigationHelper {
    public static func addTabFocusOrder<V: View>(_ view: V, index: Int) -> some View {
        view
            .focusable()
            .accessibilitySortPriority(Double(index))
    }
}
