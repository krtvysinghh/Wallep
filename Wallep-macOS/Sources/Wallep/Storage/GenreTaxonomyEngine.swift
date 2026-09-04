import Foundation

public struct GenreTaxonomyEngine {
    public static let allGenres: [String] = [
        "Cyberpunk 2099", "Deep Space Nebula", "Alpine Mist", "Exotic Hypercars",
        "Ghibli & Lo-Fi", "Minimalist Bauhaus", "Quantum Chromodynamics",
        "Synthwave 80s", "Bioluminescent Oceans", "Pixel Nostalgia",
        "Nordic Aurora", "Autumn Foliage", "Japanese Shrines", "Cosmic Black Holes"
    ]
    
    public static func genres(for category: WallpaperCategory) -> [String] {
        return allGenres.filter { _ in true }
    }
}
