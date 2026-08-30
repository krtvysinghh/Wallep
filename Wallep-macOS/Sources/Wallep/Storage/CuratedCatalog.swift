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
        let rawThemes: [(category: WallpaperCategory, authors: [String], titles: [String], tags: [String])] = [
            (
                .cyberpunk,
                ["NeonDreams", "KowloonLab", "SyntheticFlow", "CyberBlade", "NeoTokyo64", "ArasakaArch", "ChromaCity"],
                [
                    "Neo-Tokyo Shinjuku Rain Alley", "Blade Runner 2099 Megastructure", "Shibuya Cyber Hologram Crossing",
                    "Ghost In The Shell Cybernetic Net", "Akihabara Midnight Arcade Horizon", "Dystopian High-Rise Acid Fog",
                    "Holographic Golden Koi Over Skyway", "Quantum Matrix Stream in Osaka", "Cyberpunk Underground Maglev Station",
                    "Cyber Katana Warrior in Neo-Seoul", "Flying Spinner Above Neon Metropolis", "Cybernetic Dragon Lantern Street",
                    "Synthesizer Grid City Dusk", "Holographic Geisha Billboard Tower", "Overpass Speed Highway Cyber Flow"
                ],
                ["4K HDR", "60 FPS", "Neon", "Cyberpunk", "Ray Traced"]
            ),
            (
                .space,
                ["InterstellarLab", "JamesWebbArchive", "CosmoChronicles", "NASA_Exo", "PulsarStudio", "NebulaVisions"],
                [
                    "James Webb Pillars of Creation", "Supermassive Gargantua Black Hole", "Andromeda & Milky Way Cosmic Collision",
                    "Orion Bioluminescent Stellar Cloud", "Saturn Hexagon Storm with Golden Rings", "Interstellar Einstein-Rosen Wormhole",
                    "Carina Cosmic Cliff Nursery", "Supernova Shockwave in Deep Cosmos", "Jupiter Great Red Spot Fluid Flow",
                    "Solar Prominence Flare in 8K Ultra", "Milky Way Arch Over Desert Dunes", "Kepler-452b Twilight Exoplanet",
                    "Crab Nebula Pulsar Synchrotron", "Europa Subsurface Ocean Vapor", "Cosmic Web Dark Matter Filaments"
                ],
                ["4K UHD", "HDR10", "Deep Space", "Cosmic", "Slow Motion"]
            ),
            (
                .nature,
                ["NordicAmbient", "PacificShore", "EarthCine", "AlpineVistas", "KyotoAtmosphere", "RainforestLab"],
                [
                    "Nordic Emerald Aurora Over Fjord", "Kyoto Bamboo Forest Rain Mist", "Bioluminescent Maldives Shoreline",
                    "Yosemite Valley Sunrise Mist", "Matterhorn Golden Alpine Summit", "Icelandic Volcanic Black Sand River",
                    "Cascades Evergreen Forest Fog", "Swiss Alps Melting Glacier Stream", "Amazon Rainforest Sunbeam Canopy",
                    "Pacific Ocean Sunset 60FPS Swell", "New Zealand Milford Sound Cascades", "Autumn Crimson Maple in Kyoto",
                    "Faroe Islands Cliffside Ocean Fog", "Tokyo Spring Cherry Blossom Storm", "Sahara Desert Golden Sand Waves"
                ],
                ["4K 60FPS", "ProMotion", "Relaxing", "Nature", "Ambient"]
            ),
            (
                .cars,
                ["ApexVelocity", "ShutoExpressway", "NurburgringMedia", "StuttgartMotors", "MaranelloStudio", "DriftKings"],
                [
                    "Porsche 911 GT3 RS Wet Nürburgring", "McLaren P1 Midnight Wangan Expressway", "Ferrari Daytona SP3 Golden Hour Sprint",
                    "Nissan Skyline GT-R R34 Rain Tunnel", "Lamborghini Revuelto V12 Night Drift", "BMW M4 CSL Track Attack in Mist",
                    "Aston Martin Valkyrie Aero Beast", "Audi RS6 Avant Snow Drift in Alps", "Mazda RX-7 FD3S Mountain Touge",
                    "Pagani Utopia Carbon Aerodynamics", "Porsche 918 Spyder Wet Reflections", "Shelby Cobra 427 Coastal Highway"
                ],
                ["4K 60FPS", "120 FPS", "Automotive", "Cinematic", "Motorsport"]
            ),
            (
                .anime,
                ["GhibliVibes", "MakotoSky", "KyotoAnimationArt", "LoFiStation", "SakuraDreams", "MangaMotion"],
                [
                    "Spirited Coastal Train at Dusk", "Makoto Shinkai Cumulonimbus Clouds", "Lo-Fi Midnight Study Rain with Cat",
                    "Ancient Forest Kodama Spirits", "Your Name Twilight Comet Crossing", "Cozy Tokyo Coffee Shop Window Rain",
                    "Cyber Cafe Lo-Fi Rooftop Sunset", "The Wind Rises Golden Meadow", "Sailor Moon Pastel Moonlit City",
                    "Howl's Moving Castle Alpine Meadow", "Late Night Japanese Ramen Stall", "Floating Sky Island with Airships"
                ],
                ["4K 60FPS", "Anime", "Lo-Fi", "Cozy", "Aesthetic"]
            ),
            (
                .minimalist,
                ["BauhausMotion", "PureMono", "PrismGeometry", "KineticStudio", "ZenDesignLab", "AppleClean"],
                [
                    "Minimalist Dynamic Sunbeam Horizon", "Pure Monochrome Silk Wave Physics", "Bauhaus Geometric Pendulum Flow",
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
                    "Quantum Chromodynamics Fluid Field", "Iridescent Liquid Mercury Splash Loop", "Hyper-Dimensional 4D Tesseract",
                    "Magnetic Ferrofluid Spikes Dynamic", "Bioluminescent Neural Synapse Flow", "Prismatic Diamond Light Dispersion 8K",
                    "Neon Particle Supercollider Swarm", "Molten Glass Glowing Fluid Flow", "Fractal Mandelbrot Infinite Zoom"
                ],
                ["4K UHD", "120 FPS", "Abstract", "VFX", "Shaders"]
            )
        ]
        
        let resolutions = [
            "7680x4320 (Native 8K Ultra HD)",
            "6016x3384 (6K Pro Display XDR)",
            "5120x2880 (5K Retina)",
            "3840x2160 (4K 120Hz ProMotion)"
        ]
        
        let modifiers = [
            "Original Cut", "Cinematic 4K", "Golden Hour Edition", "Midnight Horizon",
            "Atmospheric Rain", "ProMotion 120Hz", "HDR Remaster", "Studio Slow-Mo",
            "Ultra-Wide Dynamic", "Vibrant Sunset", "Deep Fog Cut", "Neon Pulse",
            "Twilight Glow", "Prismatic 8K", "Velvet Night", "Aurora Remaster"
        ]
        
        var generated: [WallpaperItem] = []
        var idCounter = 1
        
        // Interleave across categories and titles for maximum visual diversity on every scroll
        let maxVariants = 55
        for variantIndex in 0..<maxVariants {
            for theme in rawThemes {
                for (titleIdx, titleBase) in theme.titles.enumerated() {
                    let id = "wallep_\(String(format: "%04d", idCounter))"
                    let author = theme.authors[(variantIndex + titleIdx) % theme.authors.count]
                    let res = resolutions[(variantIndex + idCounter) % resolutions.count]
                    let duration = Double(25 + ((variantIndex * 11 + idCounter) % 180))
                    let mbSize = String(format: "%.1f", Double(28 + ((variantIndex * 17 + idCounter) % 90))) + "MB"
                    let likes = 450 + (idCounter * 43) % 4600
                    let isFav = (idCounter % 9 == 0)
                    
                    let mod = modifiers[(variantIndex + titleIdx) % modifiers.count]
                    let finalTitle = (variantIndex == 0) ? titleBase : "\(titleBase) (\(mod))"
                    
                    let item = WallpaperItem(
                        id: id,
                        title: finalTitle,
                        category: theme.category,
                        resolution: res,
                        duration: duration,
                        fileSize: mbSize,
                        thumbnailURL: "",
                        videoURL: URL(string: "wallep://curated/\(id)")!,
                        author: author,
                        likes: likes,
                        isFavorite: isFav,
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
