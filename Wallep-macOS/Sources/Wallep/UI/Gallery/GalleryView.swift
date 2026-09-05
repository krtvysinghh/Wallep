import SwiftUI
import UniformTypeIdentifiers

public struct GalleryView: View {
    @ObservedObject var library = LibraryManager.shared
    @ObservedObject var appState = AppState.shared
    @ObservedObject var autoChange = AutoChangeManager.shared
    @State private var hoveredItemId: String? = nil
    @State private var isDragTargeted: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 290, maximum: 380), spacing: 22)
    ]
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar: Glass Search, Auto-Change & Actions
            HStack(spacing: 14) {
                // Glass Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    TextField("Search 5,000+ 4K wallpapers...", text: $library.searchQuery)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                    if !library.searchQuery.isEmpty {
                        Button(action: { library.searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .glassmorphicSurface(cornerRadius: 12)
                .frame(maxWidth: 360)
                
                // Auto-Change Quick Toggle Pill
                Button(action: {
                    autoChange.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: autoChange.isEnabled ? "clock.arrow.2.circlepath" : "clock")
                            .font(.caption)
                            .foregroundColor(autoChange.isEnabled ? .emerald : .white.opacity(0.7))
                        Text(autoChange.isEnabled ? "Auto-Change: \(autoChange.timeRemainingString.isEmpty ? "Active" : autoChange.timeRemainingString)" : "Auto-Change: Off")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .glassmorphicSurface(cornerRadius: 12)
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
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(
                        LinearGradient(colors: [Color.indigo, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.indigo.opacity(0.4), radius: 8, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Category Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(WallpaperCategory.allCases) { category in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                library.selectedCategory = category
                            }
                        }) {
                            GlassmorphicPill(isSelected: library.selectedCategory == category) {
                                Text(category.rawValue)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 16)
            
            // Wallpapers Grid & Drag Drop Area
            ZStack {
                if library.isGeneratingDefaults && library.wallpapers.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .controlSize(.large)
                        Text("Loading 5,000+ 4K live wallpapers...")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(library.filteredWallpapers.prefix(300)) { wallpaper in
                                GlassmorphicWallpaperCard(
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
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.indigo, style: StrokeStyle(lineWidth: 3, dash: [8]))
                        .background(Color.indigo.opacity(0.2))
                        .padding(16)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.doc.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
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

public struct GlassmorphicWallpaperCard: View {
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
                        .cornerRadius(14)
                    
                    // Live Indicator & Resolution Tag
                    HStack {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(isCurrentlyActive ? Color.emerald : Color.red)
                                .frame(width: 6, height: 6)
                            Text(isCurrentlyActive ? "ACTIVE" : (wallpaper.resolution.contains("8K") ? "8K LIVE" : "4K LIVE"))
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        
                        Spacer()
                        
                        Text(wallpaper.fileSize)
                            .font(.system(size: 9, weight: .semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.white.opacity(0.9))
                            .cornerRadius(4)
                    }
                    .padding(10)
                }
                
                // Favorite Button Overlay
                Button(action: onToggleFavorite) {
                    Image(systemName: wallpaper.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(wallpaper.isFavorite ? .red : .white)
                        .font(.system(size: 14))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .padding(10)
            }
            
            // Metadata & Apply Action
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(wallpaper.title)
                        .font(.system(size: 13, weight: .semibold))
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Text("\(wallpaper.author) • \(wallpaper.category.rawValue)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: onSelect) {
                    Text(isCurrentlyActive ? "Applied" : "Apply")
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            isCurrentlyActive ?
                            AnyView(Color.emerald.opacity(0.85)) :
                            AnyView(Color.indigo.opacity(0.85))
                        )
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .disabled(isCurrentlyActive)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .padding(12)
        .glassmorphicSurface(cornerRadius: 18)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .shadow(color: isCurrentlyActive ? Color.emerald.opacity(0.3) : (isHovered ? Color.indigo.opacity(0.3) : Color.black.opacity(0.2)), radius: isHovered ? 14 : 8, x: 0, y: isHovered ? 6 : 4)
    }
}
