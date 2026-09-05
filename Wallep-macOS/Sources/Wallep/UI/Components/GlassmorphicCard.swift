import SwiftUI

public struct GlassmorphicCard<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content
    
    public init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(16)
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.24),
                                Color.white.opacity(0.06),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

public struct GlassmorphicPill<Content: View>: View {
    let isSelected: Bool
    let content: Content
    
    public init(isSelected: Bool = false, @ViewBuilder content: () -> Content) {
        self.isSelected = isSelected
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                isSelected ?
                AnyView(Color.indigo.opacity(0.85)) :
                AnyView(Rectangle().fill(.ultraThinMaterial))
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.white.opacity(0.4) : Color.white.opacity(0.15),
                        lineWidth: 1
                    )
            )
            .shadow(color: isSelected ? Color.indigo.opacity(0.4) : Color.clear, radius: 8, x: 0, y: 2)
    }
}

public extension View {
    func glassmorphicSurface(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.22),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 6)
    }
}

public extension Color {
    static let emerald = Color(red: 0.15, green: 0.85, blue: 0.45)
}

