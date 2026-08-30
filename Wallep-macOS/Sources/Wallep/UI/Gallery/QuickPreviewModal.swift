import SwiftUI

public struct QuickPreviewModal: View {
    public let wallpaper: WallpaperItem
    public let onDismiss: () -> Void
    public let onApply: () -> Void
    
    public init(wallpaper: WallpaperItem, onDismiss: @escaping () -> Void, onApply: @escaping () -> Void) {
        self.wallpaper = wallpaper
        self.onDismiss = onDismiss
        self.onApply = onApply
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: WallpaperThumbnailRenderer.shared.thumbnail(for: wallpaper, size: CGSize(width: 640, height: 360)))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(wallpaper.title).font(.title2).bold()
                    Text("\(wallpaper.category.rawValue) • \(wallpaper.resolution)").foregroundColor(.secondary)
                }
                Spacer()
                Button("Apply to Desktop", action: onApply)
                    .buttonStyle(.borderedProminent)
                Button("Close", action: onDismiss)
            }
        }
        .padding(24)
        .frame(width: 700)
    }
}
