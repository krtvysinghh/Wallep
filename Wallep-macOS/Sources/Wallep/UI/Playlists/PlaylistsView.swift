import SwiftUI

public struct PlaylistsView: View {
    @ObservedObject var playlistManager = PlaylistManager.shared
    @State private var newPlaylistName: String = ""
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Playlists")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                TextField("New Playlist Name...", text: $newPlaylistName)
                    .textFieldStyle(.roundedBorder)
                Button("Create") {
                    guard !newPlaylistName.isEmpty else { return }
                    _ = playlistManager.createPlaylist(name: newPlaylistName)
                    newPlaylistName = ""
                }
            }
            
            ForEach(playlistManager.playlists) { pl in
                HStack {
                    Image(systemName: "music.note.list")
                        .foregroundColor(.indigo)
                    Text(pl.name)
                        .font(.headline)
                    Spacer()
                    Text("\(pl.wallpaperIDs.count) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
            }
        }
        .padding(24)
    }
}
