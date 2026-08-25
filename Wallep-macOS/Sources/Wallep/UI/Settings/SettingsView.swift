import SwiftUI

public struct SettingsView: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var powerManager = PowerManager.shared
    @ObservedObject var lockSync = LockScreenSync.shared
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Section: Power & Energy Management
                VStack(alignment: .leading, spacing: 12) {
                    Label("Power & Energy Management", systemImage: "bolt.batteryblock.fill")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Toggle(isOn: $appState.autoPauseOnBattery) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pause on Battery Power")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Instantly pauses live video playback when running on battery to achieve 0% extra battery drain.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                        
                        Toggle(isOn: $appState.autoPauseOnFullScreen) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Pause when Fullscreen Apps Active")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Suspends AVPlayer rendering when games or apps occupy the entire screen.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                    }
                    .padding(16)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                }
                
                // Section: Multi-Display
                VStack(alignment: .leading, spacing: 12) {
                    Label("Displays & Multi-Monitor", systemImage: "display.2")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Active Screen Feeds (\(appState.wallpaperManager.displayFeeds.count) Connected)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(Array(appState.wallpaperManager.displayFeeds.enumerated()), id: \.offset) { index, feed in
                            HStack {
                                Image(systemName: "display")
                                Text("Display \(index + 1): \(Int(feed.screen.frame.width))x\(Int(feed.screen.frame.height)) @ \(Int(feed.screen.backingScaleFactor))x")
                                    .font(.caption)
                                Spacer()
                                Text("Active Level: Desktop (kCGDesktopWindowLevel)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(8)
                            .background(Color.primary.opacity(0.04))
                            .cornerRadius(8)
                        }
                    }
                    .padding(16)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                }
                
                // Section: Lock Screen & System
                VStack(alignment: .leading, spacing: 12) {
                    Label("Lock Screen & Startup", systemImage: "lock.desktopcomputer")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Toggle(isOn: $lockSync.isLockScreenSyncEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sync with macOS Lock Screen")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Automatically syncs current live wallpaper frame with Apple's native lock screen pipeline.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                        
                        Toggle(isOn: $appState.launchAtLogin) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Launch Wallep at Login")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Starts Wallep silently in the macOS MenuBar when your Mac boots.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(.switch)
                    }
                    .padding(16)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(12)
                }
                
                // Section: About & Open Source
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wallep for macOS — Open Source")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("Version 1.0.0 (Native Swift & AppKit) • Licensed under MIT")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .padding(28)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}
