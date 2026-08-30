import SwiftUI

public struct ActiveGlowBorder: ViewModifier {
    public let isActive: Bool
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.indigo : Color.clear, lineWidth: 2.5)
                    .shadow(color: isActive ? Color.indigo.opacity(0.6) : Color.clear, radius: 8)
            )
    }
}
