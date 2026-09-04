import SwiftUI

public struct ResolutionBadgeView: View {
    public let resolution: String
    
    public init(resolution: String) {
        self.resolution = resolution
    }
    
    public var body: some View {
        Text(resolution.contains("8K") ? "8K ULTRA" : (resolution.contains("6K") ? "6K XDR" : (resolution.contains("5K") ? "5K RETINA" : "4K LIVE")))
            .font(.system(size: 9, weight: .bold))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}
