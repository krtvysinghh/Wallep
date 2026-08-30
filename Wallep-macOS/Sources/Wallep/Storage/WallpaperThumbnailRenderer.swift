import Cocoa
import SwiftUI
import CoreGraphics

public final class WallpaperThumbnailRenderer {
    public static let shared = WallpaperThumbnailRenderer()
    
    private let cache = NSCache<NSString, NSImage>()
    
    private init() {
        cache.countLimit = 1000
        cache.totalCostLimit = 200 * 1024 * 1024 // 200MB
    }
    
    public func thumbnail(for item: WallpaperItem, size: CGSize = CGSize(width: 360, height: 200)) -> NSImage {
        let cacheKey = NSString(string: "\(item.id)_\(item.title)_\(Int(size.width))x\(Int(size.height))")
        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }
        
        if !item.thumbnailURL.isEmpty && FileManager.default.fileExists(atPath: item.thumbnailURL),
           let fileImage = NSImage(contentsOfFile: item.thumbnailURL) {
            cache.setObject(fileImage, forKey: cacheKey)
            return fileImage
        }
        
        let rendered = renderSemanticArtwork(for: item, size: size)
        cache.setObject(rendered, forKey: cacheKey)
        return rendered
    }
    
    private func renderSemanticArtwork(for item: WallpaperItem, size: CGSize) -> NSImage {
        let width = Int(size.width)
        let height = Int(size.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let ctx = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return NSImage(size: size)
        }
        
        // 64-bit FNV-1a Hash based on item ID and full Title
        var hash: UInt64 = 14695981039346656037
        for byte in "\(item.id):\(item.title)".utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1099511628211
        }
        
        var seed = hash
        func rand() -> Double {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            return Double((seed >> 32) & 0xFFFFFF) / Double(0xFFFFFF)
        }
        
        let lower = item.title.lowercased()
        
        // 1. Render Sky Background matching the theme
        renderSemanticSky(ctx: ctx, size: size, lower: lower, category: item.category, rand: rand)
        
        // 2. Render Semantic Content Based on Title Keywords
        if lower.contains("train") || lower.contains("coastal") || lower.contains("rail") {
            renderCoastalTrainScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("study") || lower.contains("cat") || lower.contains("lo-fi") || lower.contains("coffee") || lower.contains("cafe") || lower.contains("ramen") || lower.contains("room") {
            renderLoFiWindowScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("cloud") || lower.contains("shinkai") || lower.contains("wind rises") || lower.contains("meadow") {
            renderToweringCloudsScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("comet") || lower.contains("your name") || lower.contains("meteor") || lower.contains("twilight") {
            renderCometCrossingScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("torii") || lower.contains("shrine") || lower.contains("spirits") || lower.contains("mononoke") || lower.contains("ancient") {
            renderMistyShrineScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("porsche") || lower.contains("gt3") || lower.contains("mclaren") || lower.contains("ferrari") || lower.contains("skyline") || lower.contains("lamborghini") || lower.contains("bmw") || lower.contains("valkyrie") || lower.contains("audi") || lower.contains("mazda") || lower.contains("pagani") || lower.contains("cobra") {
            renderSportsCarProfileScene(ctx: ctx, size: size, lower: lower, rand: rand)
        } else if lower.contains("wangan") || lower.contains("tunnel") || lower.contains("expressway") || lower.contains("highway") || lower.contains("drift") || lower.contains("touge") {
            renderHighwayTunnelPerspectiveScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("black hole") || lower.contains("gargantua") {
            renderBlackHoleAccretionScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("pillars") || lower.contains("james webb") || lower.contains("nebula") || lower.contains("orion") || lower.contains("carina") || lower.contains("supernova") {
            renderDeepSpaceNebulaScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("saturn") || lower.contains("jupiter") || lower.contains("kepler") || lower.contains("europa") || lower.contains("exoplanet") || lower.contains("ring") {
            renderPlanetarySystemScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("aurora") || lower.contains("fjord") || lower.contains("nordic") {
            renderAuroraFjordScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("bamboo") || lower.contains("kyoto") || lower.contains("forest") || lower.contains("rainforest") || lower.contains("canopy") {
            renderBambooForestScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("yosemite") || lower.contains("matterhorn") || lower.contains("alps") || lower.contains("mountain") || lower.contains("glacier") || lower.contains("cascades") {
            renderAlpineMountainScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("wave") || lower.contains("ocean") || lower.contains("sunset") || lower.contains("maldives") || lower.contains("shore") {
            renderOceanWaveSunsetScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("cherry blossom") || lower.contains("sakura") || lower.contains("maple") || lower.contains("autumn") {
            renderBlossomPetalScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("blade runner") || lower.contains("shinjuku") || lower.contains("shibuya") || lower.contains("akihabara") || lower.contains("megastructure") || lower.contains("matrix") || lower.contains("cyber") {
            renderCyberpunkMetropolisScene(ctx: ctx, size: size, rand: rand)
        } else if lower.contains("silk") || lower.contains("dune") || lower.contains("sand") || lower.contains("minimal") || lower.contains("apple") || lower.contains("quartz") || lower.contains("pendulum") || lower.contains("bauhaus") {
            renderMinimalistArchitecturalScene(ctx: ctx, size: size, lower: lower, rand: rand)
        } else {
            renderAbstractFluidDynamicsScene(ctx: ctx, size: size, lower: lower, rand: rand)
        }
        
        // 3. Subtle Cinema Vignette
        let vigColors = [NSColor.clear.cgColor, NSColor(calibratedWhite: 0.0, alpha: 0.45).cgColor] as CFArray
        if let vig = CGGradient(colorsSpace: colorSpace, colors: vigColors, locations: [0.55, 1.0]) {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            ctx.drawRadialGradient(vig, startCenter: center, startRadius: 0, endCenter: center, endRadius: max(size.width, size.height) * 0.75, options: [])
        }
        
        guard let cgImg = ctx.makeImage() else {
            return NSImage(size: size)
        }
        return NSImage(cgImage: cgImg, size: size)
    }
    
    // MARK: - Dynamic Semantic Sky
    private func renderSemanticSky(ctx: CGContext, size: CGSize, lower: String, category: WallpaperCategory, rand: () -> Double) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let (c1, c2, c3): (NSColor, NSColor, NSColor)
        
        if lower.contains("sunset") || lower.contains("golden hour") || lower.contains("dusk") {
            c1 = NSColor(calibratedRed: 0.08, green: 0.02, blue: 0.12, alpha: 1.0)
            c2 = NSColor(calibratedRed: 0.85, green: 0.25, blue: 0.20, alpha: 1.0)
            c3 = NSColor(calibratedRed: 1.00, green: 0.70, blue: 0.25, alpha: 1.0)
        } else if lower.contains("cyber") || lower.contains("neon") || lower.contains("blade runner") {
            c1 = NSColor(calibratedRed: 0.04, green: 0.01, blue: 0.10, alpha: 1.0)
            c2 = NSColor(calibratedRed: 0.55, green: 0.05, blue: 0.45, alpha: 1.0)
            c3 = NSColor(calibratedRed: 0.00, green: 0.80, blue: 0.95, alpha: 1.0)
        } else if lower.contains("space") || lower.contains("black hole") || lower.contains("nebula") || lower.contains("cosmos") {
            c1 = NSColor(calibratedRed: 0.01, green: 0.01, blue: 0.04, alpha: 1.0)
            c2 = NSColor(calibratedRed: 0.25, green: 0.08, blue: 0.45, alpha: 1.0)
            c3 = NSColor(calibratedRed: 0.10, green: 0.35, blue: 0.75, alpha: 1.0)
        } else if lower.contains("aurora") || lower.contains("bamboo") || lower.contains("nature") || lower.contains("forest") {
            c1 = NSColor(calibratedRed: 0.01, green: 0.05, blue: 0.08, alpha: 1.0)
            c2 = NSColor(calibratedRed: 0.05, green: 0.35, blue: 0.25, alpha: 1.0)
            c3 = NSColor(calibratedRed: 0.20, green: 0.85, blue: 0.55, alpha: 1.0)
        } else if lower.contains("minimal") || lower.contains("monochrome") || lower.contains("silk") {
            let val = 0.1 + 0.15 * rand()
            c1 = NSColor(calibratedWhite: CGFloat(val), alpha: 1.0)
            c2 = NSColor(calibratedWhite: CGFloat(val + 0.25), alpha: 1.0)
            c3 = NSColor(calibratedWhite: CGFloat(val + 0.55), alpha: 1.0)
        } else {
            let hue = rand()
            c1 = NSColor(calibratedHue: CGFloat(hue), saturation: 0.8, brightness: 0.12, alpha: 1.0)
            c2 = NSColor(calibratedHue: CGFloat((hue + 0.25).truncatingRemainder(dividingBy: 1.0)), saturation: 0.85, brightness: 0.45, alpha: 1.0)
            c3 = NSColor(calibratedHue: CGFloat((hue + 0.50).truncatingRemainder(dividingBy: 1.0)), saturation: 0.90, brightness: 0.85, alpha: 1.0)
        }
        
        let cgColors = [c1.cgColor, c2.cgColor, c3.cgColor] as CFArray
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: [0.0, 0.55, 1.0]) {
            ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: size.width, y: 0), options: [])
        }
    }
    
    // MARK: - Semantic Scenes
    
    // 1. Coastal Train (Spirited Away style)
    private func renderCoastalTrainScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Horizon Water Line
        let waterY = size.height * 0.38
        ctx.setFillColor(NSColor(calibratedWhite: 0.02, alpha: 0.9).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: waterY))
        
        // Train Bridge Track Rails
        ctx.setStrokeColor(NSColor(calibratedRed: 0.95, green: 0.5, blue: 0.2, alpha: 0.8).cgColor)
        ctx.setLineWidth(2.0)
        ctx.move(to: CGPoint(x: 0, y: waterY + 2))
        ctx.addLine(to: CGPoint(x: size.width, y: waterY + 2))
        ctx.strokePath()
        
        // Train Car Silhouettes with glowing windows
        let carW: CGFloat = 70
        let carH: CGFloat = 28
        let carY = waterY + 4
        
        for c in 0..<3 {
            let carX = CGFloat(c) * (carW + 6) + 30
            ctx.setFillColor(NSColor(calibratedRed: 0.15, green: 0.08, blue: 0.08, alpha: 0.95).cgColor)
            ctx.fill(CGRect(x: carX, y: carY, width: carW, height: carH))
            
            // Warm golden passenger windows
            ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.4, alpha: 0.95).cgColor)
            for w in 0..<4 {
                let winX = carX + CGFloat(w) * 15 + 6
                ctx.fill(CGRect(x: winX, y: carY + 8, width: 10, height: 12))
            }
        }
        
        // Water reflections
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.7, blue: 0.3, alpha: 0.25).cgColor)
        ctx.fill(CGRect(x: 30, y: waterY - 14, width: 220, height: 10))
    }
    
    // 2. Lo-Fi Study / Rain Window
    private func renderLoFiWindowScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Window Frame
        ctx.setFillColor(NSColor(calibratedRed: 0.06, green: 0.04, blue: 0.08, alpha: 0.98).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width * 0.15, height: size.height))
        ctx.fill(CGRect(x: size.width * 0.85, y: 0, width: size.width * 0.15, height: size.height))
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.28))
        
        // Desk Silhouette
        let deskY = size.height * 0.28
        ctx.setFillColor(NSColor(calibratedRed: 0.08, green: 0.05, blue: 0.06, alpha: 1.0).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: deskY))
        
        // Desk Lamp Cone of Light
        let lampX = size.width * 0.25
        let lampY = deskY + 35
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.35, alpha: 0.2).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: lampX, y: lampY))
        ctx.addLine(to: CGPoint(x: lampX - 60, y: deskY))
        ctx.addLine(to: CGPoint(x: lampX + 60, y: deskY))
        ctx.closePath()
        ctx.fillPath()
        
        // Desk Lamp fixture
        ctx.setFillColor(NSColor(calibratedRed: 0.2, green: 0.15, blue: 0.15, alpha: 1.0).cgColor)
        ctx.fill(CGRect(x: lampX - 6, y: deskY, width: 12, height: 40))
        ctx.fillEllipse(in: CGRect(x: lampX - 14, y: lampY - 8, width: 28, height: 16))
        
        // Sleeping Cat Silhouette on Desk
        let catX = size.width * 0.65
        ctx.setFillColor(NSColor(calibratedRed: 0.02, green: 0.02, blue: 0.03, alpha: 1.0).cgColor)
        ctx.fillEllipse(in: CGRect(x: catX, y: deskY, width: 34, height: 18))
        ctx.fillEllipse(in: CGRect(x: catX + 22, y: deskY + 6, width: 14, height: 14))
        
        // Rain droplets on window glass
        ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: 0.4).cgColor)
        for _ in 0..<35 {
            let rx = CGFloat(rand()) * (size.width * 0.7) + size.width * 0.15
            let ry = CGFloat(rand()) * (size.height * 0.6) + size.height * 0.3
            ctx.fillEllipse(in: CGRect(x: rx, y: ry, width: 1.5, height: 4.5))
        }
    }
    
    // 3. Towering Clouds (Makoto Shinkai)
    private func renderToweringCloudsScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // God-rays piercing from top
        ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.75, alpha: 0.2).cgColor)
        ctx.setLineWidth(14.0)
        let sunX = size.width * 0.7
        for i in 0..<6 {
            ctx.move(to: CGPoint(x: sunX, y: size.height))
            ctx.addLine(to: CGPoint(x: CGFloat(i) * (size.width / 5), y: 0))
            ctx.strokePath()
        }
        
        // Monumental Layered Cumulonimbus Clouds
        for l in 0..<3 {
            let cloudHue = (l == 0) ? 0.08 : ((l == 1) ? 0.85 : 0.60)
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(cloudHue), saturation: 0.35, brightness: CGFloat(0.95 - Double(l) * 0.2), alpha: 0.85).cgColor)
            
            for _ in 0..<6 {
                let cx = CGFloat(rand()) * size.width
                let cy = CGFloat(0.15 + Double(l) * 0.15 + rand() * 0.2) * size.height
                let cr = CGFloat(45 + rand() * 55)
                ctx.fillEllipse(in: CGRect(x: cx - cr, y: cy - cr, width: cr * 2, height: cr * 1.6))
            }
        }
    }
    
    // 4. Comet Twilight Crossing (Your Name)
    private func renderCometCrossingScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Starry twilight
        for _ in 0..<70 {
            let sx = CGFloat(rand()) * size.width
            let sy = CGFloat(rand()) * size.height
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.4 + 0.6 * rand())).cgColor)
            ctx.fillEllipse(in: CGRect(x: sx, y: sy, width: 2, height: 2))
        }
        
        // Dual Splitting Comet
        let cometStart = CGPoint(x: size.width * 0.15, y: size.height * 0.85)
        let cometEnd1 = CGPoint(x: size.width * 0.85, y: size.height * 0.35)
        let cometEnd2 = CGPoint(x: size.width * 0.88, y: size.height * 0.25)
        
        // Trail 1
        ctx.setStrokeColor(NSColor(calibratedRed: 0.2, green: 0.8, blue: 1.0, alpha: 0.9).cgColor)
        ctx.setLineWidth(4.0)
        ctx.move(to: cometStart)
        ctx.addLine(to: cometEnd1)
        ctx.strokePath()
        
        // Trail 2 (Split)
        ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.4, blue: 0.7, alpha: 0.85).cgColor)
        ctx.setLineWidth(3.0)
        ctx.move(to: CGPoint(x: size.width * 0.45, y: size.height * 0.62))
        ctx.addLine(to: cometEnd2)
        ctx.strokePath()
        
        // Comet Nucleus Glow
        ctx.setFillColor(NSColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(x: cometEnd1.x - 5, y: cometEnd1.y - 5, width: 10, height: 10))
        ctx.fillEllipse(in: CGRect(x: cometEnd2.x - 4, y: cometEnd2.y - 4, width: 8, height: 8))
    }
    
    // 5. Misty Shrine & Giant Moon
    private func renderMistyShrineScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Giant Textured Moon
        let mR = size.height * 0.38
        let mCenter = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.92, blue: 0.78, alpha: 0.95).cgColor)
        ctx.fillEllipse(in: CGRect(x: mCenter.x - mR, y: mCenter.y - mR, width: mR * 2, height: mR * 2))
        
        // Ancient Mountain Ridges in Mist
        ctx.setFillColor(NSColor(calibratedRed: 0.05, green: 0.03, blue: 0.08, alpha: 0.9).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: size.height * 0.3))
        ctx.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.48))
        ctx.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.32))
        ctx.addLine(to: CGPoint(x: size.width, y: size.height * 0.4))
        ctx.addLine(to: CGPoint(x: size.width, y: 0))
        ctx.closePath()
        ctx.fillPath()
        
        // Torii Shrine Gate in foreground
        let gW: CGFloat = 36
        let gH: CGFloat = 52
        let gX = size.width * 0.5
        ctx.setFillColor(NSColor(calibratedRed: 0.02, green: 0.01, blue: 0.03, alpha: 1.0).cgColor)
        ctx.fill(CGRect(x: gX - gW / 2, y: 0, width: 5, height: gH))
        ctx.fill(CGRect(x: gX + gW / 2 - 5, y: 0, width: 5, height: gH))
        ctx.fill(CGRect(x: gX - gW / 2 - 6, y: gH - 8, width: gW + 12, height: 6))
        ctx.fill(CGRect(x: gX - gW / 2 - 2, y: gH - 18, width: gW + 4, height: 4))
    }
    
    // 6. Sports Car Profile (Porsche 911, McLaren, Ferrari)
    private func renderSportsCarProfileScene(ctx: CGContext, size: CGSize, lower: String, rand: () -> Double) {
        // Wet Asphalt Ground Reflection
        let groundY = size.height * 0.28
        ctx.setFillColor(NSColor(calibratedRed: 0.03, green: 0.03, blue: 0.05, alpha: 1.0).cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: groundY))
        
        // Car Silhouette
        let carW: CGFloat = 160
        let carH: CGFloat = 42
        let carX = (size.width - carW) / 2
        let carY = groundY + 4
        
        // Body paint
        let paintHue: Double = lower.contains("porsche") ? 0.02 : (lower.contains("mclaren") ? 0.08 : (lower.contains("skyline") ? 0.6 : 0.98))
        ctx.setFillColor(NSColor(calibratedHue: CGFloat(paintHue), saturation: 0.9, brightness: 0.85, alpha: 1.0).cgColor)
        
        // Aerodynamic Coupe Body Curve
        ctx.beginPath()
        ctx.move(to: CGPoint(x: carX, y: carY + 8))
        ctx.addCurve(to: CGPoint(x: carX + 45, y: carY + 38), control1: CGPoint(x: carX + 15, y: carY + 10), control2: CGPoint(x: carX + 30, y: carY + 35))
        ctx.addCurve(to: CGPoint(x: carX + 115, y: carY + 38), control1: CGPoint(x: carX + 65, y: carY + 42), control2: CGPoint(x: carX + 95, y: carY + 42))
        ctx.addCurve(to: CGPoint(x: carX + carW, y: carY + 12), control1: CGPoint(x: carX + 135, y: carY + 32), control2: CGPoint(x: carX + 150, y: carY + 14))
        ctx.addLine(to: CGPoint(x: carX + carW - 10, y: carY + 4))
        ctx.addLine(to: CGPoint(x: carX + 8, y: carY + 4))
        ctx.closePath()
        ctx.fillPath()
        
        // Wheels
        ctx.setFillColor(NSColor(calibratedWhite: 0.02, alpha: 1.0).cgColor)
        ctx.fillEllipse(in: CGRect(x: carX + 22, y: carY - 6, width: 28, height: 28))
        ctx.fillEllipse(in: CGRect(x: carX + carW - 50, y: carY - 6, width: 28, height: 28))
        
        // Glowing Brake Calipers
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.1, alpha: 0.9).cgColor)
        ctx.fillEllipse(in: CGRect(x: carX + 30, y: carY + 2, width: 12, height: 12))
        ctx.fillEllipse(in: CGRect(x: carX + carW - 42, y: carY + 2, width: 12, height: 12))
        
        // Glowing LED Headlight & Taillight Beams
        ctx.setFillColor(NSColor(calibratedRed: 0.0, green: 0.9, blue: 1.0, alpha: 0.95).cgColor)
        ctx.fill(CGRect(x: carX, y: carY + 12, width: 8, height: 4))
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 0.95).cgColor)
        ctx.fill(CGRect(x: carX + carW - 6, y: carY + 14, width: 6, height: 4))
        
        // Light reflection on wet track
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 0.3).cgColor)
        ctx.fill(CGRect(x: carX + carW - 10, y: groundY - 12, width: 80, height: 6))
    }
    
    // 7. Highway Tunnel Perspective (Wangan / Midnight Expressway)
    private func renderHighwayTunnelPerspectiveScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        let vanish = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        // Perspective Tunnel Arches
        ctx.setLineWidth(2.5)
        for i in 1...6 {
            let scale = CGFloat(i) / 6.0
            let w = size.width * scale
            let h = size.height * scale
            let color = (i % 2 == 0) ? NSColor(calibratedRed: 0.0, green: 0.85, blue: 1.0, alpha: 0.7) : NSColor(calibratedRed: 1.0, green: 0.2, blue: 0.6, alpha: 0.7)
            ctx.setStrokeColor(color.cgColor)
            ctx.stroke(CGRect(x: vanish.x - w / 2, y: vanish.y - h / 2, width: w, height: h))
        }
        
        // Vanishing Speed Streaks
        ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.1, alpha: 0.85).cgColor)
        ctx.setLineWidth(3.0)
        ctx.move(to: vanish)
        ctx.addLine(to: CGPoint(x: size.width * 0.2, y: 0))
        ctx.move(to: vanish)
        ctx.addLine(to: CGPoint(x: size.width * 0.8, y: 0))
        ctx.strokePath()
    }
    
    // 8. Black Hole Gargantua (Interstellar Accretion Disk)
    private func renderBlackHoleAccretionScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        let c = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        let r: CGFloat = 38
        
        // Background Star Distortion
        for _ in 0..<90 {
            let sx = CGFloat(rand()) * size.width
            let sy = CGFloat(rand()) * size.height
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.3 + 0.7 * rand())).cgColor)
            ctx.fillEllipse(in: CGRect(x: sx, y: sy, width: 2, height: 2))
        }
        
        // Curved Upper Photon Ring (Gravitational Lensing)
        ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.65, blue: 0.2, alpha: 0.9).cgColor)
        ctx.setLineWidth(7.0)
        ctx.strokeEllipse(in: CGRect(x: c.x - r * 1.5, y: c.y - r * 1.5, width: r * 3.0, height: r * 3.0))
        
        // Equatorial Accretion Disk
        ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.45, alpha: 0.95).cgColor)
        ctx.setLineWidth(10.0)
        ctx.strokeEllipse(in: CGRect(x: c.x - r * 2.5, y: c.y - r * 0.4, width: r * 5.0, height: r * 0.8))
        
        // Pure Black Event Horizon Core
        ctx.setFillColor(NSColor.black.cgColor)
        ctx.fillEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
    }
    
    // 9. Deep Space Nebula (James Webb Pillars)
    private func renderDeepSpaceNebulaScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Multi-tier Star Clusters with 8-point diffraction spikes
        for _ in 0..<80 {
            let sx = CGFloat(rand()) * size.width
            let sy = CGFloat(rand()) * size.height
            let sr = CGFloat(0.6 + rand() * 2.2)
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.4 + 0.6 * rand())).cgColor)
            ctx.fillEllipse(in: CGRect(x: sx - sr, y: sy - sr, width: sr * 2, height: sr * 2))
        }
        
        // Giant Gaseous Cosmic Dust Pillars
        for p in 0..<3 {
            let px = size.width * CGFloat(0.25 + Double(p) * 0.25)
            let pw = CGFloat(40 + rand() * 30)
            let ph = size.height * CGFloat(0.5 + rand() * 0.35)
            
            ctx.setFillColor(NSColor(calibratedRed: 0.45, green: 0.15, blue: 0.35, alpha: 0.75).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: px - pw / 2, y: 0))
            ctx.addCurve(to: CGPoint(x: px + pw / 2, y: ph), control1: CGPoint(x: px - pw * 0.8, y: ph * 0.4), control2: CGPoint(x: px + pw * 0.8, y: ph * 0.8))
            ctx.addLine(to: CGPoint(x: px + pw / 2, y: 0))
            ctx.closePath()
            ctx.fillPath()
        }
    }
    
    // 10. Planetary System (Saturn & Gas Giants)
    private func renderPlanetarySystemScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        let pR = size.height * 0.32
        let pCenter = CGPoint(x: size.width * 0.35, y: size.height * 0.5)
        
        // Planet Sphere with Atmospheric Cloud Bands
        ctx.setFillColor(NSColor(calibratedRed: 0.85, green: 0.65, blue: 0.35, alpha: 1.0).cgColor)
        ctx.fillEllipse(in: CGRect(x: pCenter.x - pR, y: pCenter.y - pR, width: pR * 2, height: pR * 2))
        
        // Planet Ring Band
        ctx.setStrokeColor(NSColor(calibratedRed: 0.95, green: 0.85, blue: 0.65, alpha: 0.75).cgColor)
        ctx.setLineWidth(8.0)
        ctx.strokeEllipse(in: CGRect(x: pCenter.x - pR * 2.2, y: pCenter.y - pR * 0.4, width: pR * 4.4, height: pR * 0.8))
    }
    
    // 11. Aurora Fjord
    private func renderAuroraFjordScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Aurora Curtains in Sky
        ctx.setLineWidth(10.0)
        for i in 0..<4 {
            let hue = (i % 2 == 0) ? 0.38 : 0.82
            ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(hue), saturation: 0.95, brightness: 1.0, alpha: 0.55).cgColor)
            let y = size.height * CGFloat(0.55 + Double(i) * 0.08)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addCurve(to: CGPoint(x: size.width, y: y), control1: CGPoint(x: size.width * 0.3, y: y + 40), control2: CGPoint(x: size.width * 0.7, y: y - 40))
            ctx.strokePath()
        }
        
        // Fjord Cliff Silhouettes
        ctx.setFillColor(NSColor(calibratedRed: 0.02, green: 0.04, blue: 0.06, alpha: 0.95).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: size.height * 0.45))
        ctx.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.2))
        ctx.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.2))
        ctx.addLine(to: CGPoint(x: size.width, y: size.height * 0.5))
        ctx.addLine(to: CGPoint(x: size.width, y: 0))
        ctx.closePath()
        ctx.fillPath()
    }
    
    // 12. Bamboo Forest (Kyoto)
    private func renderBambooForestScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Bamboo Vertical Stalks
        let count = 14 + Int(rand() * 8)
        let w = size.width / CGFloat(count)
        
        for i in 0..<count {
            let bx = CGFloat(i) * w + CGFloat(rand() * 8)
            let stalkW = CGFloat(4.0 + rand() * 5.0)
            ctx.setFillColor(NSColor(calibratedRed: 0.08, green: 0.25, blue: 0.15, alpha: 0.85).cgColor)
            ctx.fill(CGRect(x: bx, y: 0, width: stalkW, height: size.height))
            
            // Stalk Segment Nodes
            ctx.setFillColor(NSColor(calibratedRed: 0.15, green: 0.45, blue: 0.25, alpha: 0.9).cgColor)
            for s in 0..<6 {
                let sy = CGFloat(s) * (size.height / 5) + CGFloat(rand() * 10)
                ctx.fill(CGRect(x: bx - 1, y: sy, width: stalkW + 2, height: 3))
            }
        }
    }
    
    // 13. Alpine Mountain (Matterhorn, Yosemite)
    private func renderAlpineMountainScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Mountain Summit with Snowy Glaciers
        ctx.setFillColor(NSColor(calibratedRed: 0.08, green: 0.06, blue: 0.12, alpha: 0.95).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: size.height * 0.25))
        ctx.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.72)) // Peak
        ctx.addLine(to: CGPoint(x: size.width, y: size.height * 0.18))
        ctx.addLine(to: CGPoint(x: size.width, y: 0))
        ctx.closePath()
        ctx.fillPath()
        
        // Snow Cap
        ctx.setFillColor(NSColor.white.cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: size.width * 0.45, y: size.height * 0.72))
        ctx.addLine(to: CGPoint(x: size.width * 0.40, y: size.height * 0.58))
        ctx.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.62))
        ctx.addLine(to: CGPoint(x: size.width * 0.50, y: size.height * 0.56))
        ctx.closePath()
        ctx.fillPath()
    }
    
    // 14. Ocean Wave Sunset
    private func renderOceanWaveSunsetScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Horizon Sun
        let sunR = size.height * 0.22
        ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.3, alpha: 0.95).cgColor)
        ctx.fillEllipse(in: CGRect(x: size.width * 0.5 - sunR, y: size.height * 0.4 - sunR, width: sunR * 2, height: sunR * 2))
        
        // Ocean Crest Swell
        ctx.setFillColor(NSColor(calibratedRed: 0.02, green: 0.15, blue: 0.25, alpha: 0.9).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addCurve(to: CGPoint(x: size.width, y: 0), control1: CGPoint(x: size.width * 0.35, y: size.height * 0.45), control2: CGPoint(x: size.width * 0.7, y: size.height * 0.1))
        ctx.closePath()
        ctx.fillPath()
        
        // Wave Whitecap Foam
        ctx.setStrokeColor(NSColor.white.cgColor)
        ctx.setLineWidth(3.0)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.32))
        ctx.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.38))
        ctx.strokePath()
    }
    
    // 15. Cherry Blossom Petals
    private func renderBlossomPetalScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        // Tree Branch Silhouette
        ctx.setStrokeColor(NSColor(calibratedRed: 0.05, green: 0.02, blue: 0.04, alpha: 1.0).cgColor)
        ctx.setLineWidth(8.0)
        ctx.move(to: CGPoint(x: 0, y: size.height * 0.8))
        ctx.addCurve(to: CGPoint(x: size.width * 0.6, y: size.height * 0.9), control1: CGPoint(x: size.width * 0.2, y: size.height * 0.7), control2: CGPoint(x: size.width * 0.4, y: size.height * 0.85))
        ctx.strokePath()
        
        // Drifting Pink Sakura Petals
        for _ in 0..<45 {
            let px = CGFloat(rand()) * size.width
            let py = CGFloat(rand()) * size.height
            ctx.setFillColor(NSColor(calibratedRed: 1.0, green: 0.65, blue: 0.8, alpha: CGFloat(0.6 + 0.4 * rand())).cgColor)
            ctx.fillEllipse(in: CGRect(x: px, y: py, width: 8, height: 4))
        }
    }
    
    // 16. Cyberpunk Metropolis
    private func renderCyberpunkMetropolisScene(ctx: CGContext, size: CGSize, rand: () -> Double) {
        let bCount = 9
        let bW = size.width / CGFloat(bCount)
        ctx.setFillColor(NSColor(calibratedWhite: 0.03, alpha: 0.95).cgColor)
        
        for i in 0..<bCount {
            let bH = (0.3 + 0.5 * rand()) * size.height
            let bx = CGFloat(i) * bW
            ctx.fill(CGRect(x: bx, y: 0, width: bW - 2, height: bH))
            
            // Neon billboard / window cluster
            let hue = (i % 2 == 0) ? 0.85 : 0.52
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(hue), saturation: 0.95, brightness: 1.0, alpha: 0.9).cgColor)
            for _ in 0..<3 {
                let wx = bx + CGFloat(rand() * Double(bW - 6)) + 2
                let wy = CGFloat(rand() * Double(bH - 12)) + 4
                ctx.fill(CGRect(x: wx, y: wy, width: 3, height: 4))
            }
            ctx.setFillColor(NSColor(calibratedWhite: 0.03, alpha: 0.95).cgColor)
        }
    }
    
    // 17. Minimalist Architecture & Clean Geometry
    private func renderMinimalistArchitecturalScene(ctx: CGContext, size: CGSize, lower: String, rand: () -> Double) {
        if lower.contains("silk") || lower.contains("wave") {
            ctx.setLineWidth(3.0)
            for i in 0..<5 {
                ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.3 + 0.15 * rand())).cgColor)
                let y = CGFloat(i) * (size.height / 5)
                ctx.beginPath()
                ctx.move(to: CGPoint(x: 0, y: y))
                ctx.addCurve(to: CGPoint(x: size.width, y: y), control1: CGPoint(x: size.width * 0.35, y: y + 40), control2: CGPoint(x: size.width * 0.7, y: y - 40))
                ctx.strokePath()
            }
        } else if lower.contains("sunbeam") || lower.contains("horizon") {
            ctx.setStrokeColor(NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.2, alpha: 0.9).cgColor)
            ctx.setLineWidth(3.0)
            ctx.move(to: CGPoint(x: 0, y: size.height * 0.45))
            ctx.addLine(to: CGPoint(x: size.width, y: size.height * 0.45))
            ctx.strokePath()
        } else {
            // Bauhaus Disc & Intersecting Light Beam
            let dR = size.height * 0.28
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: 0.85).cgColor)
            ctx.fillEllipse(in: CGRect(x: size.width * 0.5 - dR, y: size.height * 0.5 - dR, width: dR * 2, height: dR * 2))
        }
    }
    
    // 18. Abstract Fluid & Shaders
    private func renderAbstractFluidDynamicsScene(ctx: CGContext, size: CGSize, lower: String, rand: () -> Double) {
        for i in 0..<6 {
            let r = CGFloat(25 + rand() * 45)
            let x = CGFloat(rand()) * size.width
            let y = CGFloat(rand()) * size.height
            let hue = CGFloat((Double(i) * 0.18 + rand() * 0.2).truncatingRemainder(dividingBy: 1.0))
            ctx.setFillColor(NSColor(calibratedHue: hue, saturation: 0.85, brightness: 0.95, alpha: 0.45).cgColor)
            ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        }
    }
}
