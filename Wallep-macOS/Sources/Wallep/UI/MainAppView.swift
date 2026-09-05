import SwiftUI

public struct MainAppView: View {
    @ObservedObject var appState = AppState.shared
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.title2)
                        .foregroundColor(.indigo)
                    Text("Wallep")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 4) {
                        SidebarTabButton(
                            title: "Gallery",
                            icon: "square.grid.2x2.fill",
                            badge: "5000+",
                            isSelected: appState.activeTab == .gallery,
                            action: { appState.activeTab = .gallery }
                        )
                        
                        SidebarTabButton(
                            title: "Studio",
                            icon: "wand.and.stars",
                            badge: "Creator",
                            isSelected: appState.activeTab == .studio,
                            action: { appState.activeTab = .studio }
                        )
                        
                        SidebarTabButton(
                            title: "Soundscapes",
                            icon: "waveform.circle.fill",
                            badge: "Audio",
                            isSelected: appState.activeTab == .soundscapes,
                            action: { appState.activeTab = .soundscapes }
                        )
                        
                        SidebarTabButton(
                            title: "Widgets",
                            icon: "square.dashed.inset.filled",
                            badge: "HUD",
                            isSelected: appState.activeTab == .widgets,
                            action: { appState.activeTab = .widgets }
                        )
                        
                        SidebarTabButton(
                            title: "Playlists",
                            icon: "music.note.list",
                            badge: nil,
                            isSelected: appState.activeTab == .playlists,
                            action: { appState.activeTab = .playlists }
                        )
                        
                        SidebarTabButton(
                            title: "History",
                            icon: "clock.arrow.circlepath",
                            badge: nil,
                            isSelected: appState.activeTab == .history,
                            action: { appState.activeTab = .history }
                        )
                        
                        SidebarTabButton(
                            title: "Settings",
                            icon: "gearshape.fill",
                            badge: nil,
                            isSelected: appState.activeTab == .settings,
                            action: { appState.activeTab = .settings }
                        )
                    }
                    .padding(.horizontal, 8)
                }
                
                Spacer()
                
                // Bottom Power status badge
                HStack(spacing: 8) {
                    Circle()
                        .fill(appState.wallpaperManager.isPlaybackActive ? Color.green : Color.orange)
                        .frame(width: 8, height: 8)
                    Text(appState.wallpaperManager.isPlaybackActive ? "Playback Active" : "Paused (Energy Saved)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(14)
            }
            .frame(minWidth: 200, idealWidth: 220, maxWidth: 260)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.6))
        } detail: {
            Group {
                switch appState.activeTab {
                case .gallery:
                    GalleryView()
                case .studio:
                    StudioView()
                case .soundscapes:
                    SoundscapesView()
                case .widgets:
                    WidgetsView()
                case .playlists:
                    PlaylistsView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
        }
        .frame(minWidth: 960, minHeight: 620)
    }
}

struct SidebarTabButton: View {
    let title: String
    let icon: String
    let badge: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white : .indigo)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                Spacer()
                
                if let b = badge {
                    Text(b)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white.opacity(0.2) : Color.indigo.opacity(0.15))
                        .foregroundColor(isSelected ? .white : .indigo)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.indigo : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
