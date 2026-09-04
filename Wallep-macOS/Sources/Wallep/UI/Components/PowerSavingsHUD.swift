import SwiftUI

public struct PowerSavingsHUD: View {
    public init() {}
    
    public var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.emerald400)
                .frame(width: 8, height: 8)
            Text("0.0% CPU • Hardware Decoded")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

extension Color {
    static let emerald400 = Color(red: 0.2, green: 0.8, blue: 0.4)
}
