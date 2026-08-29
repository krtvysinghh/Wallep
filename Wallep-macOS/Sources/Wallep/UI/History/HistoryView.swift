import SwiftUI

public struct HistoryView: View {
    @ObservedObject var historyManager = HistoryManager.shared
    @ObservedObject var appState = AppState.shared
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently Applied Wallpapers")
                    .font(.headline)
                Spacer()
                if !historyManager.history.isEmpty {
                    Button("Clear History") {
                        historyManager.clear()
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            if historyManager.history.isEmpty {
                Text("No recent wallpapers recorded.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(historyManager.history) { item in
                            Button(action: {
                                appState.selectWallpaper(item)
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Image(nsImage: WallpaperThumbnailRenderer.shared.thumbnail(for: item, size: CGSize(width: 140, height: 85)))
                                        .resizable()
                                        .frame(width: 140, height: 85)
                                        .cornerRadius(8)
                                    Text(item.title)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}
