import Cocoa

public struct ExtendedPresets {
    public static let catalog: [DefaultWallpaperGenerator.Preset] = [
        DefaultWallpaperGenerator.Preset(
            id: "preset_cyberpunk_neon",
            title: "Neo Tokyo Rain Skyline",
            category: .cyberpunk,
            author: "Wallep Studio",
            colors: [
                NSColor(calibratedRed: 0.05, green: 0.02, blue: 0.12, alpha: 1.0),
                NSColor(calibratedRed: 0.60, green: 0.05, blue: 0.50, alpha: 1.0),
                NSColor(calibratedRed: 0.00, green: 0.75, blue: 0.90, alpha: 1.0)
            ],
            likes: 2450
        ),
        DefaultWallpaperGenerator.Preset(
            id: "preset_space_jameswebb",
            title: "James Webb Pillars of Creation",
            category: .space,
            author: "Interstellar Lab",
            colors: [
                NSColor(calibratedRed: 0.02, green: 0.02, blue: 0.06, alpha: 1.0),
                NSColor(calibratedRed: 0.35, green: 0.10, blue: 0.55, alpha: 1.0),
                NSColor(calibratedRed: 0.85, green: 0.40, blue: 0.20, alpha: 1.0)
            ],
            likes: 3120
        ),
        DefaultWallpaperGenerator.Preset(
            id: "preset_nature_kyoto",
            title: "Kyoto Bamboo Rain Mist",
            category: .nature,
            author: "Nature Lab",
            colors: [
                NSColor(calibratedRed: 0.02, green: 0.08, blue: 0.05, alpha: 1.0),
                NSColor(calibratedRed: 0.10, green: 0.45, blue: 0.30, alpha: 1.0),
                NSColor(calibratedRed: 0.30, green: 0.80, blue: 0.55, alpha: 1.0)
            ],
            likes: 1890
        ),
        DefaultWallpaperGenerator.Preset(
            id: "preset_cars_nurburgring",
            title: "GT3 RS Nürburgring Wet Lap",
            category: .cars,
            author: "Apex Velocity",
            colors: [
                NSColor(calibratedRed: 0.08, green: 0.04, blue: 0.04, alpha: 1.0),
                NSColor(calibratedRed: 0.80, green: 0.15, blue: 0.10, alpha: 1.0),
                NSColor(calibratedRed: 1.00, green: 0.60, blue: 0.10, alpha: 1.0)
            ],
            likes: 2780
        ),
        DefaultWallpaperGenerator.Preset(
            id: "preset_anime_ghibli",
            title: "Spirited Away Sea Train",
            category: .anime,
            author: "Ghibli Vibes",
            colors: [
                NSColor(calibratedRed: 0.05, green: 0.10, blue: 0.25, alpha: 1.0),
                NSColor(calibratedRed: 0.40, green: 0.60, blue: 0.85, alpha: 1.0),
                NSColor(calibratedRed: 0.95, green: 0.65, blue: 0.40, alpha: 1.0)
            ],
            likes: 3400
        ),
        DefaultWallpaperGenerator.Preset(
            id: "preset_minimal_quartz",
            title: "Quartz Prism Caustic Light",
            category: .minimalist,
            author: "Minimal Design Lab",
            colors: [
                NSColor(calibratedWhite: 0.10, alpha: 1.0),
                NSColor(calibratedWhite: 0.40, alpha: 1.0),
                NSColor(calibratedWhite: 0.85, alpha: 1.0)
            ],
            likes: 1650
        )
    ]
}
