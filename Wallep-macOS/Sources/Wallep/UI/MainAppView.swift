import SwiftUI

public struct MainAppView: View {
    @ObservedObject var appState = AppState.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Ambient Liquid Glass Gradient Background
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.06, blue: 0.14),
                    Color(red: 0.05, green: 0.04, blue: 0.10),
                    Color(red: 0.02, green: 0.02, blue: 0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle ambient color orbs behind glass
            GeometryReader { geo in
                Circle()
                    .fill(Color.indigo.opacity(0.18))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(x: -80, y: -60)
                
                Circle()
                    .fill(Color.purple.opacity(0.14))
                    .frame(width: 350, height: 350)
                    .blur(radius: 90)
                    .offset(x: geo.size.width - 250, y: geo.size.height - 250)
            }
            .ignoresSafeArea()
            
            NavigationSplitView {
                // Frosted Glass Sidebar
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 32, height: 32)
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Wallep")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("8K Live Engine")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
                    .padding(.bottom, 14)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 5) {
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
                        .padding(.horizontal, 10)
                    }
                    
                    Spacer()
                    
                    // Bottom Glass Power Status Indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(appState.wallpaperManager.isPlaybackActive ? Color.emerald : Color.orange)
                            .frame(width: 8, height: 8)
                            .shadow(color: appState.wallpaperManager.isPlaybackActive ? Color.emerald.opacity(0.6) : Color.orange.opacity(0.6), radius: 4)
                        
                        Text(appState.wallpaperManager.isPlaybackActive ? "Playback Active" : "Paused (Energy Save)")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.75))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .glassmorphicSurface(cornerRadius: 12)
                    .padding(14)
                }
                .frame(minWidth: 210, idealWidth: 230, maxWidth: 260)
                .background(.ultraThinMaterial)
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
                .background(Color.clear)
            }
        }
        .frame(minWidth: 980, minHeight: 640)
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
            HStack(spacing: 11) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .indigo)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.85))
                
                Spacer()
                
                if let b = badge {
                    Text(b)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white.opacity(0.25) : Color.indigo.opacity(0.2))
                        .foregroundColor(isSelected ? .white : .indigo)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(isSelected ? 0.3 : 0.1), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(
                isSelected ?
                AnyView(
                    LinearGradient(
                        colors: [Color.indigo.opacity(0.85), Color.purple.opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                ) :
                AnyView(Color.clear)
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.indigo.opacity(0.4) : Color.clear, radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
