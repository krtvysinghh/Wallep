import SwiftUI

public struct GalleryView: View {
    @ObservedObject var library = LibraryManager.shared
    @ObservedObject var appState = AppState.shared
    @State private var hoveredItemId: String? = nil
    @State private var showImportDialog: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 280, maximum: 360), spacing: 20)
    ]
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar: Search & Actions
            HStack(spacing: 16) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search 2700+ 4K wallpapers...", text: $library.searchQuery)
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
                .frame(maxWidth: 380)
                
                Spacer()
                
                // Import Custom Video Button
                Button(action: {
                    selectCustomVideo()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                        Text("Import Custom Video")
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
            
            // Wallpapers Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(library.filteredWallpapers) { wallpaper in
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
                // Background thumbnail / mockup
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.indigo.opacity(0.6), Color.purple.opacity(0.8), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                    
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
                        .background(Color.black.opacity(0.4))
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
                    Text(isCurrentlyActive ? "Set" : "Apply")
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
