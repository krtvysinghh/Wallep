import SwiftUI

public struct FloatingControlWidget: View {
    @ObservedObject var wallpaperManager = WallpaperManager.shared
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 12) {
            Button(action: { AppState.shared.togglePlayback() }) {
                Image(systemName: wallpaperManager.isPlaybackActive ? "pause.fill" : "play.fill")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color.black.opacity(0.8))
        .cornerRadius(16)
    }
}
