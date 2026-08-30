import SwiftUI

public struct MiniPlaylistSwitcher: View {
    @ObservedObject var playlistManager = PlaylistManager.shared
    
    public init() {}
    
    public var body: some View {
        Menu("Switch Playlist") {
            ForEach(playlistManager.playlists) { pl in
                Button(pl.name) {
                    // Activate playlist
                }
            }
        }
    }
}
