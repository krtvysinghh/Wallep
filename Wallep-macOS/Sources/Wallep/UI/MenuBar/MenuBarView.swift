import SwiftUI

public struct MenuBarView: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var wallpaperManager = WallpaperManager.shared
    @ObservedObject var powerManager = PowerManager.shared
    
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
                    Text("NOW PLAYING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 64, height: 40)
                            
                            Image(systemName: "play.tv.fill")
                                .foregroundColor(.indigo)
                        }
                        
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
                    .padding(10)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                
                Divider()
            }
            
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
                        Text("Browse 4K Wallpaper Gallery (2700+)")
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
        .frame(width: 320)
    }
    
    private func openFullWindow(tab: ActiveTab) {
        appState.activeTab = tab
        if let window = NSApplication.shared.windows.first(where: { $0.title == "Wallep" }) {
            window.makeKeyAndOrderFront(nil)
            NSApplication.shared.activate(ignoringOtherApps: true)
        } else {
            let win = NSWindow(
                contentRect: NSRect(x: 100, y: 100, width: 1080, height: 720),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            win.title = "Wallep"
            win.center()
            win.contentView = NSHostingView(rootView: MainAppView())
            win.makeKeyAndOrderFront(nil)
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
}
