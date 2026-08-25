import SwiftUI

public struct MenuBarView: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var wallpaperManager = WallpaperManager.shared
    @ObservedObject var powerManager = PowerManager.shared
    @ObservedObject var autoChange = AutoChangeManager.shared
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header: Status & Brand
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .foregroundColor(.indigo)
                    Text("Wallep")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Battery / Power badge
                HStack(spacing: 4) {
                    Image(systemName: powerManager.isOnBattery ? "battery.75" : "bolt.fill")
                        .font(.caption2)
                    Text(powerManager.isOnBattery ? "Battery Aware" : "AC Power")
                        .font(.caption2)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(6)
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider()
            
            // Current Wallpaper Preview
            if let current = wallpaperManager.currentWallpaper {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("NOW PLAYING")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Next wallpaper button
                        Button(action: {
                            autoChange.triggerNextWallpaper()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "forward.fill")
                                    .font(.system(size: 9))
                                Text("Next")
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundColor(.indigo)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack(spacing: 10) {
                        Image(nsImage: WallpaperThumbnailRenderer.shared.thumbnail(for: current, size: CGSize(width: 120, height: 75)))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 42)
                            .cornerRadius(6)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(current.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Text("\(current.category.rawValue) • \(current.resolution)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            appState.togglePlayback()
                        }) {
                            Image(systemName: wallpaperManager.isPlaybackActive ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(.indigo)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(8)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                
                Divider()
            }
            
            // Auto-Change Quick Toggle Row
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: autoChange.isEnabled ? "clock.arrow.2.circlepath" : "clock")
                        .font(.caption)
                        .foregroundColor(autoChange.isEnabled ? .emerald : .secondary)
                    Text(autoChange.isEnabled ? "Auto-Change (\(autoChange.timeRemainingString.isEmpty ? "Active" : autoChange.timeRemainingString))" : "Auto-Change Disabled")
                        .font(.caption)
                }
                
                Spacer()
                
                Toggle("", isOn: $autoChange.isEnabled)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            
            Divider()
            
            // Quick Volume & Display Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: appState.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $appState.volume, in: 0.0...1.0)
                        .accentColor(.indigo)
                    
                    Button(action: {
                        appState.isMuted.toggle()
                    }) {
                        Text(appState.isMuted ? "Unmute" : "Mute")
                            .font(.caption2)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                }
                
                HStack {
                    Image(systemName: "display.2")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(wallpaperManager.displayFeeds.count) Display(s) Active")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            
            Divider()
            
            // Action Buttons
            VStack(spacing: 4) {
                Button(action: {
                    openFullWindow(tab: .gallery)
                }) {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                        Text("Browse 4K Wallpaper Gallery (5,000+)")
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    openFullWindow(tab: .studio)
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Open Wallpaper Studio")
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    openFullWindow(tab: .settings)
                }) {
                    HStack {
                        Image(systemName: "gearshape")
                        Text("Preferences & Settings...")
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                
                Divider()
                    .padding(.vertical, 2)
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit Wallep")
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .frame(width: 330)
    }
    
    private func openFullWindow(tab: ActiveTab) {
        AppDelegate.shared?.statusPopover?.performClose(nil)
        AppDelegate.showMainWindow(tab: tab)
    }
}
