import SwiftUI
import UniformTypeIdentifiers

public struct GalleryView: View {
    @ObservedObject var library = LibraryManager.shared
    @ObservedObject var appState = AppState.shared
    @ObservedObject var autoChange = AutoChangeManager.shared
    @State private var hoveredItemId: String? = nil
    @State private var isDragTargeted: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 290, maximum: 380), spacing: 20)
    ]
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar: Search, Auto-Change & Actions
            HStack(spacing: 14) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search 5,000+ 4K wallpapers...", text: $library.searchQuery)
                        .textFieldStyle(.plain)
                    if !library.searchQuery.isEmpty {
                        Button(action: { library.searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.primary.opacity(0.06))
                .cornerRadius(10)
                .frame(maxWidth: 340)
                
                // Auto-Change Quick Toggle Pill
                Button(action: {
                    autoChange.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: autoChange.isEnabled ? "clock.arrow.2.circlepath" : "clock")
                            .font(.caption)
                            .foregroundColor(autoChange.isEnabled ? .emerald : .secondary)
                        Text(autoChange.isEnabled ? "Auto-Change: \(autoChange.timeRemainingString.isEmpty ? "Active" : autoChange.timeRemainingString)" : "Auto-Change: Off")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(autoChange.isEnabled ? Color.emerald.opacity(0.15) : Color.primary.opacity(0.05))
                    .foregroundColor(autoChange.isEnabled ? .emerald : .primary)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(autoChange.isEnabled ? Color.emerald.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                // Import Custom Video Button
                Button(action: selectCustomVideo) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                        Text("Import Video")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Category Selector Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(WallpaperCategory.allCases) { category in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                library.selectedCategory = category
                            }
                        }) {
                            Text(category.rawValue)
                                .font(.subheadline)
                                .fontWeight(library.selectedCategory == category ? .semibold : .regular)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(
                                    library.selectedCategory == category ?
                                    Color.indigo : Color.primary.opacity(0.06)
                                )
                                .foregroundColor(
                                    library.selectedCategory == category ?
                                    .white : .primary
                                )
                                .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 16)
            
            Divider()
            
            // Wallpapers Grid & Drag Drop Area
            ZStack {
                if library.isGeneratingDefaults && library.wallpapers.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .controlSize(.large)
                        Text("Loading 5,000+ 4K live wallpapers...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(library.filteredWallpapers.prefix(300)) { wallpaper in
                                WallpaperCard(
                                    wallpaper: wallpaper,
                                    isHovered: hoveredItemId == wallpaper.id,
                                    isCurrentlyActive: appState.wallpaperManager.currentWallpaper?.id == wallpaper.id,
                                    onSelect: {
                                        appState.selectWallpaper(wallpaper)
                                    },
                                    onToggleFavorite: {
                                        library.toggleFavorite(for: wallpaper.id)
                                    }
                                )
                                .onHover { hovering in
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        self.hoveredItemId = hovering ? wallpaper.id : nil
                                    }
                                }
                            }
                        }
                        .padding(24)
                    }
                }
                
                // Drag and Drop Overlay
                if isDragTargeted {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.indigo, style: StrokeStyle(lineWidth: 3, dash: [8]))
                        .background(Color.indigo.opacity(0.15))
                        .padding(16)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.doc.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.indigo)
                                Text("Drop video to import as Live Wallpaper")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        )
                }
            }
            .onDrop(of: [.fileURL], isTargeted: $isDragTargeted) { providers in
                handleDrop(providers: providers)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func selectCustomVideo() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.movie, .quickTimeMovie, .mpeg4Movie]
        
        if panel.runModal() == .OK, let url = panel.url {
            if let item = library.importCustomVideo(at: url) {
                appState.selectWallpaper(item)
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            
            DispatchQueue.main.async {
                if let imported = library.importCustomVideo(at: url) {
                    appState.selectWallpaper(imported)
                }
            }
        }
        return true
    }
}

public struct WallpaperCard: View {
    public let wallpaper: WallpaperItem
    public let isHovered: Bool
    public let isCurrentlyActive: Bool
    public let onSelect: () -> Void
    public let onToggleFavorite: () -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                // Background thumbnail rendered uniquely per wallpaper
                ZStack(alignment: .bottomLeading) {
                    Image(nsImage: WallpaperThumbnailRenderer.shared.thumbnail(for: wallpaper))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                    
                    // Live Indicator & Resolution Tag
                    HStack {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(isCurrentlyActive ? Color.green : Color.red)
                                .frame(width: 6, height: 6)
                            Text(isCurrentlyActive ? "ACTIVE" : "4K LIVE")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.65))
                        .cornerRadius(6)
                        
                        Spacer()
                        
                        Text(wallpaper.fileSize)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(4)
                    }
                    .padding(10)
                }
                
                // Favorite Heart Button
                Button(action: onToggleFavorite) {
                    Image(systemName: wallpaper.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(wallpaper.isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCurrentlyActive ? Color.indigo : Color.clear, lineWidth: 3)
            )
            .shadow(color: isHovered ? Color.indigo.opacity(0.3) : Color.black.opacity(0.1), radius: isHovered ? 12 : 4, y: isHovered ? 6 : 2)
            
            // Metadata & Apply Button
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(wallpaper.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text("\(wallpaper.author) • \(wallpaper.category.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onSelect) {
                    Text(isCurrentlyActive ? "Active" : "Apply")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(isCurrentlyActive ? Color.secondary.opacity(0.2) : Color.indigo)
                        .foregroundColor(isCurrentlyActive ? .secondary : .white)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(16)
    }
}

extension Color {
    static let emerald = Color(red: 0.15, green: 0.80, blue: 0.45)
}
