import SwiftUI

public struct DisplayPickerView: View {
    @ObservedObject var wallpaperManager = WallpaperManager.shared
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(wallpaperManager.displayFeeds.enumerated()), id: \.offset) { index, feed in
                VStack(spacing: 4) {
                    Image(systemName: "display")
                        .font(.title2)
                        .foregroundColor(.indigo)
                    Text("Display \(index + 1)")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .padding(8)
                .background(Color.primary.opacity(0.05))
                .cornerRadius(8)
            }
        }
    }
}
