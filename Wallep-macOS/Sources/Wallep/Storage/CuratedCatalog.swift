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
        let categoryThemes: [WallpaperCategory: (authors: [String], titles: [String])] = [
            .cyberpunk: (
                ["NeoTokyo64", "ArasakaArch", "ChromaCity", "KowloonLab", "SyntheticFlow", "CyberBlade", "GlitchMatrix", "VoltRunner", "LaserGrid", "HoloDistrict"],
                [
                    "Neo-Tokyo Shinjuku Rain Alley", "Blade Runner 2099 Megastructure", "Shibuya Cyber Hologram Crossing",
                    "Ghost In The Shell Cybernetic Net", "Akihabara Midnight Arcade Horizon", "Dystopian High-Rise Acid Fog",
                    "Holographic Golden Koi Over Skyway", "Quantum Matrix Stream in Osaka", "Cyberpunk Underground Maglev Station",
                    "Cyber Katana Warrior in Neo-Seoul", "Flying Spinner Above Neon Metropolis", "Cybernetic Dragon Lantern Street",
                    "Synthesizer Grid City Dusk", "Holographic Geisha Billboard Tower", "Overpass Speed Highway Cyber Flow",
                    "Kowloon Walled City Neon Maze", "Chongqing Cyber Fog Monorail", "Night City Afterlife Bar Horizon",
                    "Megacity One Aerial Highway Drone", "Hacker Terminal in Rain Alley", "Neon Cyberpunk Ramen Stall 3AM",
                    "Cybernetic Cherry Blossom Pavilion", "Augmented Reality Rain Storm", "High-Tech Cyber Yakuza Hideout",
                    "Bioluminescent Skyport Terminal", "Sub-level Matrix Data Haven", "Android Dreaming of Electric Sheep",
                    "Cyberpunk Bullet Train in Mist", "Neo-Kyoto Shinto Shrine with Holo Torii", "Floating Cybernetic Billboard Clouds"
                ]
            ),
            .space: (
                ["InterstellarLab", "JamesWebbArchive", "CosmoChronicles", "NASA_Exo", "PulsarStudio", "NebulaVisions", "AstroSphere", "DeepCosmos", "VoyagerArts", "HubbleHeritage"],
                [
                    "James Webb Pillars of Creation", "Supermassive Gargantua Black Hole", "Andromeda & Milky Way Cosmic Collision",
                    "Orion Bioluminescent Stellar Cloud", "Saturn Hexagon Storm with Golden Rings", "Interstellar Einstein-Rosen Wormhole",
                    "Carina Cosmic Cliff Nursery", "Supernova Shockwave in Deep Cosmos", "Jupiter Great Red Spot Fluid Flow",
                    "Solar Prominence Flare in 8K Ultra", "Milky Way Arch Over Desert Dunes", "Kepler-452b Twilight Exoplanet",
                    "Crab Nebula Pulsar Synchrotron", "Europa Subsurface Ocean Vapor", "Cosmic Web Dark Matter Filaments",
                    "Horsehead Dark Dust Nebula", "Tarantula Cosmic Web Supercluster", "Ring Nebula Sapphire Core",
                    "Trappist-1 Seven Planetary Sunset", "Magnetar High-Energy Gamma Burst", "Io Volcanic Eruption Over Jupiter",
                    "Titan Methane Lakes Twilight", "Milky Way Galactic Core Lensing", "Sombrero Galaxy Star Dust Rim",
                    "Voyager 1 Golden Record Interstellar Drift", "Eagle Nebula Stellar Hatchery", "Oort Cloud Cometary Twilight",
                    "Enceladus Ice Geysers in Space", "Helix Nebula Eye of God Cosmic Horizon", "Quantum Spacetime Multiverse Foam"
                ]
            ),
            .nature: (
                ["NordicAmbient", "PacificShore", "EarthCine", "AlpineVistas", "KyotoAtmosphere", "RainforestLab", "PatagoniaVibe", "IcelandicAero", "SavannahChronicles", "ZenGardens"],
                [
                    "Nordic Emerald Aurora Over Fjord", "Kyoto Bamboo Forest Rain Mist", "Bioluminescent Maldives Shoreline",
                    "Yosemite Valley Sunrise Mist", "Matterhorn Golden Alpine Summit", "Icelandic Volcanic Black Sand River",
                    "Cascades Evergreen Forest Fog", "Swiss Alps Melting Glacier Stream", "Amazon Rainforest Sunbeam Canopy",
                    "Pacific Ocean Sunset 60FPS Swell", "New Zealand Milford Sound Cascades", "Autumn Crimson Maple in Kyoto",
                    "Faroe Islands Cliffside Ocean Fog", "Tokyo Spring Cherry Blossom Storm", "Sahara Desert Golden Sand Waves",
                    "Banff Moraine Lake Turquoise Water", "Torres del Paine Sunrise Glow", "Antarctica Glacier Iceberg Blue",
                    "Mount Fuji Silhouette with Cherry Blossom", "Redwood Giant Forest God-Rays", "Hokkaido Snow Blizzard Pine Trees",
                    "Santorini White Cliff Sunset Breeze", "Great Barrier Reef Coral Lagoon", "Scottish Highlands Misty Loch",
                    "Victoria Falls Golden Rainbow Spray", "Tahoe Emerald Bay Sunset Reflection", "Dolomites Jagged Peaks Pink Sunset",
                    "Norwegian Lofoten Islands Midnight Sun", "Monument Valley Starry Desert Horizon", "Plitvice Lakes Crystal Waterfalls"
                ]
            ),
            .cars: (
                ["ApexVelocity", "ShutoExpressway", "NurburgringMedia", "StuttgartMotors", "MaranelloStudio", "DriftKings", "TougeSpirit", "AeroDynamics", "LeMansHeritage", "MonacoGrand"],
                [
                    "Porsche 911 GT3 RS Wet Nürburgring", "McLaren P1 Midnight Wangan Expressway", "Ferrari Daytona SP3 Golden Hour Sprint",
                    "Nissan Skyline GT-R R34 Rain Tunnel", "Lamborghini Revuelto V12 Night Drift", "BMW M4 CSL Track Attack in Mist",
                    "Aston Martin Valkyrie Aero Beast", "Audi RS6 Avant Snow Drift in Alps", "Mazda RX-7 FD3S Mountain Touge",
                    "Pagani Utopia Carbon Aerodynamics", "Porsche 918 Spyder Wet Reflections", "Shelby Cobra 427 Coastal Highway",
                    "Koenigsegg Jesko Attack Speed Run", "Ferrari F40 Golden Hour Alpine Touge", "Lexus LFA V10 Symphony in Rain",
                    "Mercedes-AMG One Formula 1 Track Lapping", "Bugatti Chiron Super Sport Top Speed Horizon", "Honda NSX Type-R Suzuka Wet Run",
                    "Ford GT Heritage Gulf Racing Dusk", "Toyota Supra MK4 Midnight Shuto Pull", "Lancia Stratos Group B Forest Rally",
                    "Subaru Impreza 22B STI Snow Drift", "Aston Martin DB5 London Midnight Rain", "McLaren Senna Carbon Aero Attack",
                    "Pagani Zonda Cinque Mountain Pass Echo", "Ferrari 250 GTO Monterey Coast Sunrise", "Porsche Carrera GT V10 Tunnel Roar",
                    "Lamborghini Countach LP5000 Retro Drift", "Nissan GT-R Nismo Tsukuba Circuit Attack", "Rimac Nevera Electric Hypercar Launch"
                ]
            ),
            .anime: (
                ["GhibliVibes", "MakotoSky", "KyotoAnimationArt", "LoFiStation", "SakuraDreams", "MangaMotion", "TokyoLofi", "StudioSpirits", "CozyAnimeArt", "TwilightAnime"],
                [
                    "Spirited Coastal Train at Dusk", "Makoto Shinkai Cumulonimbus Clouds", "Lo-Fi Midnight Study Rain with Cat",
                    "Ancient Forest Kodama Spirits", "Your Name Twilight Comet Crossing", "Cozy Tokyo Coffee Shop Window Rain",
                    "Cyber Cafe Lo-Fi Rooftop Sunset", "The Wind Rises Golden Meadow", "Sailor Moon Pastel Moonlit City",
                    "Howl's Moving Castle Alpine Meadow", "Late Night Japanese Ramen Stall", "Floating Sky Island with Airships",
                    "Princess Mononoke Night Walker Lake", "Kiki Bakery Overlook in Mediterranean Sea", "Weathering With You Sunbeam Sky",
                    "5 Centimeters Per Second Cherry Blossoms", "A Silent Voice Bridge Koi Pond", "Suzume Red Door Twilight Grassland",
                    "Cozy Attic Rain with Vinyl Turntable", "Shinjuku Gyoen Rain Gazebo with Tea", "Akira Neo-Tokyo Cyber Highway Bike",
                    "Demon Slayer Wisteria Moonlit Shrine", "Ghibli Countryside Summer Cicada Field", "Tokyo Metro Night Ride Window Glow",
                    "Anime School Rooftop Golden Hour Wind", "Totoro Giant Tree Night Canopy", "Studio Ghibli Steaming Onsen Bathhouse",
                    "Kamogawa Riverbank Kyoto Twilight Walk", "Lo-Fi Bedroom Sunset with Sleeping Corgi", "Neon Harajuku Rain with Umbrella Silhouette"
                ]
            ),
            .minimalist: (
                ["BauhausMotion", "PureMono", "PrismGeometry", "KineticStudio", "ZenDesignLab", "AppleClean", "NordicForm", "MonochromeLab", "Geometrica", "StudioMinimal"],
                [
                    "Minimalist Dynamic Sunbeam Horizon", "Pure Monochrome Silk Wave Physics", "Bauhaus Geometric Pendulum Flow",
                    "Frosted Glass Prismatic Refractions", "Zen Sand Garden Wind Ripples", "Golden Ratio Kinetic Particles",
                    "Apple Silicon Die Macrophotography", "Minimalist Quartz Crystal Caustic Light", "Soft Gradient Mesh Fluid Diffusion",
                    "Subtle Charcoal Smoke Billow", "Iridescent Soap Bubble Film Physics", "Minimalist Horizon Sunrise Line",
                    "Brutalist Concrete Shadow Geometry", "Floating Obsidian Sphere in White Space", "Monochrome Architectural Archway Light",
                    "Titanium Brushed Metal Dynamic Flow", "Kinetic Glass Spheres Harmonic Wave", "Nordic Pine Wood Grain Ambient Glow",
                    "Pure White Sand Dune Ridge Line", "Ceramic Porcelain Bowl Soft Light", "Minimalist Solar Corona Eclipse Ring",
                    "Prismatic Light Dispersion on White Marble", "Linear Grid Kinetic Wave Horizon", "Isometric Glass Cube with Rainbow Caustics",
                    "Japanese Enso Circle Charcoal Stroke", "Subtle Liquid Silver Mercury Drop", "Minimalist Dune Horizon with Amber Sun",
                    "Frosted Acrylic Glass Layer Blur", "Pure Velvet Black Dynamic Wave Form", "Minimalist Sunset Gradient Mesh Flow"
                ]
            ),
            .abstract: (
                ["QuantumShader", "ChromaDynamics", "FractalVortex", "FluidMechanics", "SpectralLab", "HyperDimension", "VFXMaster", "NeuralArt", "PolyFlow", "ChromaWave"],
                [
                    "Quantum Chromodynamics Fluid Field", "Iridescent Liquid Mercury Splash Loop", "Hyper-Dimensional 4D Tesseract",
                    "Magnetic Ferrofluid Spikes Dynamic", "Bioluminescent Neural Synapse Flow", "Prismatic Diamond Light Dispersion 8K",
                    "Neon Particle Supercollider Swarm", "Molten Glass Glowing Fluid Flow", "Fractal Mandelbrot Infinite Zoom",
                    "Plasma Arc Electromagnetic Storm", "Holographic Iridescent Oil Slick Flow", "Audio Reactive Frequency Waveform Matrix",
                    "Bioluminescent Jellyfish Tentacle Shaders", "Cybernetic Hexagonal Grid Distortion", "Chromium Liquid Ribbon Twisting 120Hz",
                    "Subatomic Quark Glitch Collision", "Deep Ocean Thermal Vent Mineral Plume", "Synaptic Brain Wave Electrical Impulse",
                    "Rainbow Prismatic Lens Flare Dispersion", "Crystalline Growth Microscopic Timelapse", "Superconducting Quantum Levitation Field",
                    "Volumetric Cloud Smoke with Neon Lasers", "Metaballs Viscous Fluid Merging", "Non-Euclidean Geometric Tunnel Zoom",
                    "Iridescent Dragonfly Wing Structural Color", "Superheated Core Fusion Plasma Glow", "Fluid Dynamics Smoke Ribbon Dance",
                    "Fractal Julia Set Infinite Orbit", "Laser Interferometer Gravity Wave Ring", "Chroma Ripple Liquid Surface Resonance"
                ]
            )
        ]
        
        let resolutions = [
            "7680x4320 (Native 8K Ultra HD)",
            "6016x3384 (6K Pro Display XDR)",
            "5120x2880 (5K Retina)",
            "3840x2160 (4K 120Hz ProMotion)"
        ]
        
        var generated: [WallpaperItem] = []
        var idCounter = 1
        
        let categories: [WallpaperCategory] = [.cyberpunk, .space, .nature, .cars, .anime, .minimalist, .abstract]
        
        // Build 5,020 rich, interleaved, diverse wallpapers
        let totalTarget = 5020
        let rounds = (totalTarget / (categories.count * 30)) + 1
        
        for round in 0..<rounds {
            for cat in categories {
                guard let theme = categoryThemes[cat] else { continue }
                for (idx, titleBase) in theme.titles.enumerated() {
                    if generated.count >= totalTarget { break }
                    
                    let id = "wallep_\(String(format: "%04d", idCounter))"
                    let author = theme.authors[(round * 3 + idx) % theme.authors.count]
                    let res = resolutions[(round + idx + idCounter) % resolutions.count]
                    let duration = Double(20 + ((round * 13 + idx * 7) % 160))
                    let mbSize = String(format: "%.1f", Double(25 + ((round * 17 + idx * 11) % 95))) + "MB"
                    let likes = 850 + (idCounter * 73) % 9200
                    let isFav = (idCounter % 11 == 0)
                    
                    let finalTitle: String
                    if round == 0 {
                        finalTitle = titleBase
                    } else {
                        let nuances = [
                            "Director's 8K Cut", "Atmospheric Sunset", "Cinematic 120Hz",
                            "Midnight Edition", "Rain & Fog Remaster", "ProMotion Master",
                            "Golden Hour", "High-Contrast HDR", "Velvet Night",
                            "Bioluminescent 8K", "Extended Dynamic Loop", "Pure Ambient"
                        ]
                        let nuance = nuances[(round + idx) % nuances.count]
                        finalTitle = "\(titleBase) — \(nuance)"
                    }
                    
                    let item = WallpaperItem(
                        id: id,
                        title: finalTitle,
                        category: cat,
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
