import Foundation
import Cocoa

public struct CatalogPreset {
    public let id: String
    public let title: String
    public let category: WallpaperCategory
    public let resolution: String
    public let author: String
    public let tags: [String]
    public let likes: Int
    public let isRare: Bool
    public let isSpecial: Bool
}

public final class CuratedCatalog {
    public static let shared = CuratedCatalog()
    
    public private(set) var items: [WallpaperItem] = []
    
    private init() {
        generateCuratedCatalog()
    }
    
    private func generateCuratedCatalog() {
        let themes: [(category: WallpaperCategory, authors: [String], titles: [String], tags: [String])] = [
            (
                .cyberpunk,
                ["NeonDreams", "KowloonLab", "SyntheticFlow", "CyberBlade", "NeoTokyo64", "ArasakaArch", "ChromaCity"],
                [
                    "Shinjuku Rain Neon Alleyway", "Blade Runner Neo Cityscape 2099", "Shibuya Cyber Hologram Crossing",
                    "Ghost In The Shell Cyber Net", "Akihabara Midnight Arcade Glow", "Cyberpunk Megastructure Fog",
                    "Holographic Koi Over Skyway", "Quantum Matrix Data Stream", "Neon Cyberpunk Underground Metro",
                    "Dystopian Rain on High-Rise Window", "Cybernetic Android Dreams in Tokyo", "Neo-Seoul Overpass Light Trails",
                    "Futuristic Monorail Through Neon Clouds", "Cyberpunk Rooftop Katana Silhouette", "Cyberpunk Chinatown Lanterns"
                ],
                ["4K HDR", "60 FPS", "Neon", "Cyberpunk", "Ray Traced"]
            ),
            (
                .space,
                ["InterstellarLab", "JamesWebbArchive", "CosmoChronicles", "NASA_Exo", "PulsarStudio", "NebulaVisions"],
                [
                    "James Webb Deep Field Pillars of Creation", "Supermassive Black Hole Accretion Disk", "Andromeda Galaxy Collision Horizon",
                    "Orion Nebula Bioluminescent Cloud", "Saturn Hexagon Storm & Ring Transit", "Interstellar Quantum Wormhole Loop",
                    "Carina Nebula Stellar Nursery", "Supernova Shockwave in Deep Cosmos", "Jupiter Great Red Spot Fluid Dynamics",
                    "Solar Flare Prominence in 8K Ultra", "Milky Way Arch Over Desert Dunes", "Kepler-452b Twilight Horizon",
                    "Crab Nebula Pulsar Synchrotron Beam", "Europa Subsurface Ocean Vapor", "Cosmic Web Dark Matter Filaments"
                ],
                ["4K UHD", "HDR10", "NASA Archive", "Deep Space", "Slow Motion"]
            ),
            (
                .nature,
                ["NordicAmbient", "PacificShore", "EarthCine", "AlpineVistas", "KyotoAtmosphere", "RainforestLab"],
                [
                    "Nordic Emerald Aurora Borealis Fjord", "Kyoto Bamboo Forest Gentle Rain", "Bioluminescent Maldives Night Shore",
                    "Yosemite Valley Morning Mist Drift", "Matterhorn Sunrise Golden Glow", "Icelandic Volcanic River Delta 4K",
                    "Cascades Evergreen Forest Fog", "Swiss Alps Glacier Melting Stream", "Amazon Rainforest Canopy Rainstorm",
                    "Pacific Ocean Sunset Swell 60FPS", "New Zealand Milford Sound Waterfalls", "Autumn Maple Leaves Falling in Kyoto",
                    "Faroe Islands Cliffside Ocean Fog", "Cherry Blossom Blizzard in Tokyo", "Sahara Desert Dune Wind Drift"
                ],
                ["4K 60FPS", "ProMotion", "Relaxing", "Nature", "Ambient"]
            ),
            (
                .cars,
                ["ApexVelocity", "ShutoExpressway", "NurburgringMedia", "StuttgartMotors", "MaranelloStudio", "DriftKings"],
                [
                    "Porsche 911 GT3 RS Nürburgring Wet Lap", "McLaren P1 Tokyo Midnight Expressway", "Ferrari Daytona SP3 Golden Hour Run",
                    "Nissan Skyline GT-R R34 Rain Tunnel", "Lamborghini Revuelto V12 Night Drift", "BMW M4 CSL Track Attack in Mist",
                    "Aston Martin Valkyrie High Downforce Run", "Audi RS6 Avant Quattro Snow Drift", "Mazda RX-7 FD3S Midnight Highway",
                    "Pagani Utopia Carbon Aerodynamics", "Porsche 918 Spyder Rain Reflections", "Shelby Cobra 427 Coastal Highway"
                ],
                ["4K 60FPS", "120 FPS", "Automotive", "Cinematic", "Motorsport"]
            ),
            (
                .anime,
                ["GhibliVibes", "MakotoSky", "KyotoAnimationArt", "LoFiStation", "SakuraDreams", "MangaMotion"],
                [
                    "Spirited Away Coastal Train Journey", "Makoto Shinkai Summer Cumulonimbus Clouds", "Lo-Fi Midnight Study with Cat in Rain",
                    "Princess Mononoke Ancient Forest Spirits", "Your Name Twilight Comet Crossing", "Cozy Tokyo Coffee Shop Window Rain",
                    "Cyber Cafe Lo-Fi Rooftop Chill", "Wind Rises Meadow with Windmills", "Sailor Moon Pastel Moonlit City",
                    "Howl's Moving Castle Alpine Meadow", "Late Night Japanese Ramen Stall", "Floating Sky Island with Airships"
                ],
                ["4K 60FPS", "Anime", "Lo-Fi", "Cozy", "Aesthetic"]
            ),
            (
                .minimalist,
                ["BauhausMotion", "PureMono", "PrismGeometry", "KineticStudio", "ZenDesignLab", "AppleClean"],
                [
                    "Minimalist Dynamic Sunbeam Horizon", "Pure Monochrome Silk Wave Physics", "Bauhaus Geometric Pendulum Motion",
                    "Frosted Glass Prismatic Refractions", "Zen Sand Garden Wind Ripples", "Golden Ratio Kinetic Particles",
                    "Apple Silicon Die Macrophotography", "Minimalist Quartz Crystal Caustic Light", "Soft Gradient Mesh Fluid Diffusion",
                    "Subtle Charcoal Smoke Billow", "Iridescent Soap Bubble Film Physics", "Minimalist Horizon Sunrise Line"
                ],
                ["5K Retina", "ProMotion", "Minimal", "Design", "Clean"]
            ),
            (
                .abstract,
                ["QuantumShader", "ChromaDynamics", "FractalVortex", "FluidMechanics", "SpectralLab"],
                [
                    "Quantum Chromodynamics Fluid Field", "Iridescent Liquid Mercury Splash Loop", "Hyper-Dimensional 4D Tesseract Rotation",
                    "Magnetic Ferrofluid Spikes Dynamic", "Bioluminescent Jellyfish Neural Synapse", "Prismatic Diamond Light Dispersion 8K",
                    "Neon Particle Supercollider Swarm", "Molten Glass Glowing Fluid Flow", "Fractal Mandelbrot Infinite Zoom"
                ],
                ["4K UHD", "120 FPS", "Abstract", "VFX", "Shaders"]
            )
        ]
        
        var generated: [WallpaperItem] = []
        var idCounter = 1
        
        let resolutions = [
            "3840x2160 (Native 4K UHD)",
            "5120x2880 (5K Retina)",
            "3840x2160 (4K 60FPS HDR)",
            "3840x2160 (120 FPS ProMotion)"
        ]
        
        // Build 4,500+ curated items mathematically combining themes, variants, lighting, and resolutions
        for theme in themes {
            for titleBase in theme.titles {
                for variantIndex in 1...55 {
                    let id = "wallep_\(String(format: "%04d", idCounter))"
                    let author = theme.authors[variantIndex % theme.authors.count]
                    let res = resolutions[variantIndex % resolutions.count]
                    let duration = Double(30 + (variantIndex * 7) % 150)
                    let mbSize = String(format: "%.1f", Double(20 + (variantIndex * 13) % 95)) + "MB"
                    let likes = 300 + (idCounter * 37) % 4800
                    let isRare = (variantIndex % 7 == 0)
                    
                    let titleVariant: String
                    if variantIndex == 1 {
                        titleVariant = titleBase
                    } else {
                        let subThemes = ["Night Edition", "Cinematic Cut", "Golden Hour", "Midnight Loop", "Atmospheric Edit", "ProMotion 120Hz", "HDR Remaster", "Slow Motion", "Studio Cut", "Ultra-Wide Dynamic"]
                        let sub = subThemes[variantIndex % subThemes.count]
                        titleVariant = "\(titleBase) (\(sub))"
                    }
                    
                    let item = WallpaperItem(
                        id: id,
                        title: titleVariant,
                        category: theme.category,
                        resolution: res,
                        duration: duration,
                        fileSize: mbSize,
                        thumbnailURL: "",
                        videoURL: URL(string: "wallep://curated/\(id)")!,
                        author: author,
                        likes: likes,
                        isFavorite: isRare,
                        isCustom: false
                    )
                    
                    generated.append(item)
                    idCounter += 1
                }
            }
        }
        
        self.items = generated
    }
}
