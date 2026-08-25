import SwiftUI

public struct StudioView: View {
    @ObservedObject var studio = WallpaperStudio.shared
    @ObservedObject var appState = AppState.shared
    @State private var projectTitle: String = "My Ambient Wallpaper"
    @State private var brightness: Double = 0.0
    @State private var contrast: Double = 1.0
    @State private var saturation: Double = 1.0
    @State private var playbackSpeed: Double = 1.0
    @State private var selectedVideoURL: URL?
    @State private var exportMessage: String?
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 0) {
            // Left canvas / preview area
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                    
                    if let _ = selectedVideoURL {
                        VStack(spacing: 12) {
                            Image(systemName: "film.stack")
                                .font(.system(size: 48))
                                .foregroundColor(.indigo)
                            Text(projectTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Ready to render with real-time color grading")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "arrow.down.doc.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.secondary)
                            Text("Drop a video file or choose to begin")
                                .font(.headline)
                            
                            Button(action: selectVideo) {
                                Text("Choose Source Video (.mp4, .mov)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.indigo)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            // Right inspector panel
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("STUDIO PROJECT")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        TextField("Wallpaper Title", text: $projectTitle)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Divider()
                    
                    // Video Adjustments
                    VStack(alignment: .leading, spacing: 16) {
                        Text("COLOR & GRADING")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Brightness")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "%.2f", brightness))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $brightness, in: -1.0...1.0)
                                .accentColor(.indigo)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Contrast")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "%.2f", contrast))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $contrast, in: 0.0...2.0)
                                .accentColor(.indigo)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Saturation")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "%.2f", saturation))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $saturation, in: 0.0...2.0)
                                .accentColor(.indigo)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Playback Speed")
                                    .font(.caption)
                                Spacer()
                                Text(String(format: "%.2fx", playbackSpeed))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Slider(value: $playbackSpeed, in: 0.25...2.0)
                                .accentColor(.indigo)
                        }
                    }
                    
                    Divider()
                    
                    // Export Actions
                    VStack(spacing: 12) {
                        Button(action: exportLiveWallpaper) {
                            HStack {
                                if studio.isExporting {
                                    ProgressView()
                                        .controlSize(.small)
                                } else {
                                    Image(systemName: "square.and.arrow.down.fill")
                                }
                                Text(studio.isExporting ? "Rendering Live Wallpaper..." : "Export Live Wallpaper")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedVideoURL == nil ? Color.gray : Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        .disabled(selectedVideoURL == nil || studio.isExporting)
                        
                        if let msg = exportMessage {
                            Text(msg)
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding(24)
            }
            .frame(width: 320)
            .background(Color(NSColor.controlBackgroundColor))
        }
    }
    
    private func selectVideo() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.movie, .quickTimeMovie, .mpeg4Movie]
        if panel.runModal() == .OK, let url = panel.url {
            self.selectedVideoURL = url
            self.projectTitle = url.deletingPathExtension().lastPathComponent
            studio.createProject(with: url)
        }
    }
    
    private func exportLiveWallpaper() {
        guard selectedVideoURL != nil else { return }
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "\(projectTitle).mp4"
        savePanel.allowedContentTypes = [.mpeg4Movie]
        
        if savePanel.runModal() == .OK, let targetURL = savePanel.url {
            studio.exportWallpaper(to: targetURL) { result in
                switch result {
                case .success(let exportedURL):
                    self.exportMessage = "Exported successfully to \(exportedURL.lastPathComponent)"
                    if let item = appState.libraryManager.importCustomVideo(at: exportedURL, title: self.projectTitle) {
                        appState.selectWallpaper(item)
                    }
                case .failure(let error):
                    self.exportMessage = "Export error: \(error.localizedDescription)"
                }
            }
        }
    }
}
