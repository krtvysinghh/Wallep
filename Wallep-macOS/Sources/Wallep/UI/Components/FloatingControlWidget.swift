import SwiftUI

public struct FloatingControlWidget: View {
    public init() {}
    
    public var body: some View {
        HStack(spacing: 12) {
            Button(action: { AppState.shared.togglePlayback() }) {
                Image(systemName: AppState.shared.isPlaying ? "pause.fill" : "play.fill")
            }
        }
        .padding(8)
        .background(Color.black.opacity(0.8))
        .cornerRadius(16)
    }
}
