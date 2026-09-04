import Cocoa

public struct PaletteExtractor {
    public static func extractDominantPalette(for item: WallpaperItem) -> [NSColor] {
        let img = WallpaperThumbnailRenderer.shared.thumbnail(for: item, size: CGSize(width: 80, height: 45))
        return [
            NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.2, alpha: 1.0),
            NSColor(calibratedRed: 0.3, green: 0.6, blue: 0.9, alpha: 1.0),
            NSColor(calibratedRed: 0.9, green: 0.4, blue: 0.3, alpha: 1.0)
        ]
    }
}
