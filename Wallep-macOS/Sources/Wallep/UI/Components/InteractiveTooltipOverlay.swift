import SwiftUI

public struct InteractiveTooltipOverlay: ViewModifier {
    public let text: String
    
    public func body(content: Content) -> some View {
        content
            .help(text)
    }
}

public extension View {
    func wallepTooltip(_ text: String) -> some View {
        self.modifier(InteractiveTooltipOverlay(text: text))
    }
}
