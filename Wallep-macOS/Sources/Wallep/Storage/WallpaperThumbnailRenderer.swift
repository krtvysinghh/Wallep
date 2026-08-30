import Cocoa
import SwiftUI
import CoreGraphics

public final class WallpaperThumbnailRenderer {
    public static let shared = WallpaperThumbnailRenderer()
    
    private let cache = NSCache<NSString, NSImage>()
    
    private init() {
        cache.countLimit = 800
        cache.totalCostLimit = 150 * 1024 * 1024 // 150MB
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
        
        let rendered = renderUniqueArtwork(for: item, size: size)
        cache.setObject(rendered, forKey: cacheKey)
        return rendered
    }
    
    private func renderUniqueArtwork(for item: WallpaperItem, size: CGSize) -> NSImage {
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
        
        // 64-bit FNV-1a Hash
        var hash: UInt64 = 14695981039346656037
        for byte in "\(item.id):\(item.title):\(item.category.rawValue)".utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1099511628211
        }
        
        var seed = hash
        func rand() -> Double {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            return Double((seed >> 32) & 0xFFFFFF) / Double(0xFFFFFF)
        }
        
        // Dynamic Sky Palette
        let baseHue = rand()
        let paletteType = Int(rand() * 5)
        let (h1, h2, h3): (Double, Double, Double)
        
        switch paletteType {
        case 0: // Complementary High Contrast
            h1 = baseHue
            h2 = (baseHue + 0.5).truncatingRemainder(dividingBy: 1.0)
            h3 = (baseHue + 0.15).truncatingRemainder(dividingBy: 1.0)
        case 1: // Analogous Rich Mood
            h1 = baseHue
            h2 = (baseHue + 0.08).truncatingRemainder(dividingBy: 1.0)
            h3 = (baseHue + 0.16).truncatingRemainder(dividingBy: 1.0)
        case 2: // Triadic Vibrant
            h1 = baseHue
            h2 = (baseHue + 0.33).truncatingRemainder(dividingBy: 1.0)
            h3 = (baseHue + 0.66).truncatingRemainder(dividingBy: 1.0)
        case 3: // Neon Cyber Horizon
            h1 = 0.82 // Magenta
            h2 = 0.55 // Cyan
            h3 = 0.72 // Electric Purple
        default: // Golden Sunset / Twilight
            h1 = 0.04 // Deep Orange
            h2 = 0.95 // Rose Crimson
            h3 = 0.65 // Midnight Indigo
        }
        
        let c1 = NSColor(calibratedHue: CGFloat(h1), saturation: CGFloat(0.70 + 0.30 * rand()), brightness: CGFloat(0.08 + 0.15 * rand()), alpha: 1.0)
        let c2 = NSColor(calibratedHue: CGFloat(h2), saturation: CGFloat(0.75 + 0.25 * rand()), brightness: CGFloat(0.35 + 0.30 * rand()), alpha: 1.0)
        let c3 = NSColor(calibratedHue: CGFloat(h3), saturation: CGFloat(0.85 + 0.15 * rand()), brightness: CGFloat(0.75 + 0.25 * rand()), alpha: 1.0)
        
        let gradientColors = [c1.cgColor, c2.cgColor, c3.cgColor] as CFArray
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: [0.0, 0.55, 1.0]) {
            let start = CGPoint(x: CGFloat(rand()) * size.width, y: size.height)
            let end = CGPoint(x: CGFloat(rand()) * size.width, y: 0)
            ctx.drawLinearGradient(gradient, start: start, end: end, options: [])
        }
        
        // Render category specific scenes with high visual variety
        let subVariant = Int(rand() * 6)
        switch item.category {
        case .minimalist:
            renderMinimalistScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h2)
        case .cyberpunk:
            renderCyberpunkScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h1)
        case .space:
            renderSpaceScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h2)
        case .nature:
            renderNatureScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h1)
        case .cars:
            renderCarsScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h3)
        case .anime:
            renderAnimeScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h2)
        case .abstract, .all:
            renderAbstractScene(ctx: ctx, size: size, rand: rand, subVariant: subVariant, baseHue: h1)
        }
        
        // High quality edge vignette
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
    
    // MARK: - 1. Minimalist (6 Distinct Architectural & Geometric Variants)
    private func renderMinimalistScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        switch subVariant {
        case 0:
            // Flowing Silk Waves
            ctx.setLineWidth(3.0)
            let waves = 5 + Int(rand() * 4)
            for i in 0..<waves {
                ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.25 + 0.15 * rand())).cgColor)
                let y = CGFloat(i) * (size.height / CGFloat(waves))
                ctx.beginPath()
                ctx.move(to: CGPoint(x: 0, y: y))
                ctx.addCurve(
                    to: CGPoint(x: size.width, y: y + CGFloat((rand() - 0.5) * 50)),
                    control1: CGPoint(x: size.width * 0.35, y: y + 45),
                    control2: CGPoint(x: size.width * 0.70, y: y - 45)
                )
                ctx.strokePath()
            }
        case 1:
            // Bauhaus Overlapping Geometric Prisms & Disc
            let discR = CGFloat(35 + rand() * 30)
            let discX = CGFloat(0.3 + 0.4 * rand()) * size.width
            let discY = CGFloat(0.35 + 0.3 * rand()) * size.height
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.7, brightness: 0.95, alpha: 0.85).cgColor)
            ctx.fillEllipse(in: CGRect(x: discX - discR, y: discY - discR, width: discR * 2, height: discR * 2))
            
            // Angled translucent rectangle
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: 0.2).cgColor)
            ctx.fill(CGRect(x: discX - discR * 1.5, y: discY - 15, width: discR * 3, height: 30))
        case 2:
            // Solar Corona Eclipse Ring
            let r = CGFloat(45 + rand() * 20)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            ctx.setFillColor(NSColor(calibratedWhite: 0.05, alpha: 0.95).cgColor)
            ctx.fillEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
            ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.6, brightness: 1.0, alpha: 0.8).cgColor)
            ctx.setLineWidth(4.0)
            ctx.strokeEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
        case 3:
            // Minimalist Desert Sand Dunes
            for d in 0..<3 {
                ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.4, brightness: CGFloat(0.15 + Double(d) * 0.1), alpha: 0.9).cgColor)
                ctx.beginPath()
                ctx.move(to: CGPoint(x: 0, y: 0))
                let peakX = size.width * CGFloat(0.3 + Double(d) * 0.25)
                let peakY = size.height * CGFloat(0.25 + Double(d) * 0.15)
                ctx.addLine(to: CGPoint(x: 0, y: peakY * 0.5))
                ctx.addQuadCurve(to: CGPoint(x: size.width, y: peakY * 0.7), control: CGPoint(x: peakX, y: peakY))
                ctx.addLine(to: CGPoint(x: size.width, y: 0))
                ctx.closePath()
                ctx.fillPath()
            }
        case 4:
            // Diagonal Split Architecture
            ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 0.85).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: size.width * 0.65, y: size.height))
            ctx.addLine(to: CGPoint(x: size.width, y: size.height))
            ctx.addLine(to: CGPoint(x: size.width, y: 0))
            ctx.closePath()
            ctx.fillPath()
            
            // Accent Beam
            ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.8, brightness: 1.0, alpha: 0.9).cgColor)
            ctx.setLineWidth(3.0)
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: size.width * 0.65, y: size.height))
            ctx.strokePath()
        default:
            // Kinetic Pendulum Dots
            for i in 0..<12 {
                let x = CGFloat(i + 1) * (size.width / 14)
                let y = (size.height / 2) + CGFloat(sin(Double(i) * 0.5 + rand()) * 40)
                let dotR = CGFloat(3.0 + rand() * 4.0)
                ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.5 + 0.5 * rand())).cgColor)
                ctx.fillEllipse(in: CGRect(x: x - dotR, y: y - dotR, width: dotR * 2, height: dotR * 2))
            }
        }
    }
    
    // MARK: - 2. Cyberpunk (Night Megastructures, Rain Grids, Flyover Highways)
    private func renderCyberpunkScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        // Perspective Neon Highway Grid
        ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.9, brightness: 1.0, alpha: 0.35).cgColor)
        ctx.setLineWidth(1.0)
        let horizonY = size.height * 0.35
        for i in 0..<8 {
            let x = CGFloat(i) * (size.width / 7)
            ctx.move(to: CGPoint(x: size.width / 2, y: horizonY))
            ctx.addLine(to: CGPoint(x: x, y: 0))
            ctx.strokePath()
        }
        
        // Skyscrapers with holographic signage
        let bCount = 8 + Int(rand() * 6)
        let bWidth = size.width / CGFloat(bCount)
        ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 0.95).cgColor)
        for i in 0..<bCount {
            let bH = (0.25 + 0.55 * rand()) * size.height
            let bX = CGFloat(i) * bWidth
            ctx.fill(CGRect(x: bX, y: 0, width: bWidth - 2, height: bH))
            
            // Glowing neon windows / signs
            let signHue = (i % 2 == 0) ? 0.85 : 0.52
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(signHue), saturation: 0.95, brightness: 1.0, alpha: 0.85).cgColor)
            for _ in 0..<3 {
                let wX = bX + CGFloat(rand() * Double(bWidth - 6)) + 1
                let wY = CGFloat(rand() * Double(bH - 12)) + 4
                ctx.fill(CGRect(x: wX, y: wY, width: 3, height: 4))
            }
            ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 0.95).cgColor)
        }
        
        // Flying Spinner Vehicle Light Trails
        ctx.setStrokeColor(NSColor(calibratedRed: 0.0, green: 0.9, blue: 1.0, alpha: 0.8).cgColor)
        ctx.setLineWidth(2.5)
        let yTrail = size.height * CGFloat(0.45 + 0.3 * rand())
        ctx.move(to: CGPoint(x: 0, y: yTrail))
        ctx.addLine(to: CGPoint(x: size.width, y: yTrail + 15))
        ctx.strokePath()
    }
    
    // MARK: - 3. Space (Black Holes, Ringed Gas Giants, Deep Field Nebulas)
    private func renderSpaceScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        // Starfield
        for _ in 0..<80 {
            let sX = CGFloat(rand()) * size.width
            let sY = CGFloat(rand()) * size.height
            let sR = CGFloat(0.5 + rand() * 1.8)
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(0.4 + rand() * 0.6)).cgColor)
            ctx.fillEllipse(in: CGRect(x: sX - sR, y: sY - sR, width: sR * 2, height: sR * 2))
        }
        
        if subVariant % 2 == 0 {
            // Accretion Disk Black Hole (Gargantua style)
            let c = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            let r: CGFloat = 32
            // Glowing disk
            ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.9, brightness: 1.0, alpha: 0.85).cgColor)
            ctx.setLineWidth(8.0)
            ctx.strokeEllipse(in: CGRect(x: c.x - r * 2.2, y: c.y - r * 0.6, width: r * 4.4, height: r * 1.2))
            // Black hole core
            ctx.setFillColor(NSColor.black.cgColor)
            ctx.fillEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
        } else {
            // Saturnian Gas Giant with Rings
            let pR = CGFloat(28 + rand() * 30)
            let pX = CGFloat(0.25 + 0.5 * rand()) * size.width
            let pY = CGFloat(0.3 + 0.4 * rand()) * size.height
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.75, brightness: 0.9, alpha: 0.95).cgColor)
            ctx.fillEllipse(in: CGRect(x: pX - pR, y: pY - pR, width: pR * 2, height: pR * 2))
            ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: 0.6).cgColor)
            ctx.setLineWidth(3.0)
            ctx.strokeEllipse(in: CGRect(x: pX - pR * 1.8, y: pY - pR * 0.4, width: pR * 3.6, height: pR * 0.8))
        }
    }
    
    // MARK: - 4. Nature (Snowy Alpine Summits, Aurora Ribbons, Sunrises)
    private func renderNatureScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        // Aurora Curtains
        ctx.setLineWidth(6.0)
        for i in 0..<3 {
            let aColor = NSColor(calibratedHue: CGFloat((0.35 + Double(i) * 0.08 + rand() * 0.1).truncatingRemainder(dividingBy: 1.0)), saturation: 0.9, brightness: 1.0, alpha: 0.4)
            ctx.setStrokeColor(aColor.cgColor)
            let y = size.height * CGFloat(0.55 + Double(i) * 0.12)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addCurve(to: CGPoint(x: size.width, y: y), control1: CGPoint(x: size.width * 0.3, y: y + 35), control2: CGPoint(x: size.width * 0.7, y: y - 35))
            ctx.strokePath()
        }
        
        // Layered Alpine Mountain Silhouette
        for l in 0..<3 {
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.5, brightness: CGFloat(0.08 + Double(l) * 0.06), alpha: 0.9).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: 0))
            var curX: CGFloat = 0
            while curX <= size.width {
                let peakY = CGFloat(0.18 + Double(l) * 0.12 + rand() * 0.2) * size.height
                curX += CGFloat(28 + rand() * 40)
                ctx.addLine(to: CGPoint(x: curX, y: peakY))
            }
            ctx.addLine(to: CGPoint(x: size.width, y: 0))
            ctx.closePath()
            ctx.fillPath()
        }
    }
    
    // MARK: - 5. Cars (Racing Track Blur, Neon Speed Trails)
    private func renderCarsScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        for i in 0..<10 {
            let isRed = (i % 2 == 0)
            let color = isRed ? NSColor(calibratedRed: 1.0, green: 0.1, blue: 0.1, alpha: 0.85) : NSColor(calibratedRed: 0.1, green: 0.85, blue: 1.0, alpha: 0.85)
            ctx.setStrokeColor(color.cgColor)
            ctx.setLineWidth(CGFloat(2.0 + rand() * 3.5))
            
            let startY = CGFloat(0.1 + rand() * 0.4) * size.height
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: startY))
            ctx.addCurve(
                to: CGPoint(x: size.width, y: startY + CGFloat((rand() - 0.5) * 60)),
                control1: CGPoint(x: size.width * 0.4, y: startY + 25),
                control2: CGPoint(x: size.width * 0.7, y: startY - 25)
            )
            ctx.strokePath()
        }
    }
    
    // MARK: - 6. Anime (Makoto Shinkai Storm Clouds, Shrine Torii)
    private func renderAnimeScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        // Glowing Supermoon
        let mR: CGFloat = 26
        let mX = size.width * CGFloat(0.7 + 0.15 * rand())
        let mY = size.height * CGFloat(0.65 + 0.2 * rand())
        ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.3, brightness: 1.0, alpha: 0.9).cgColor)
        ctx.fillEllipse(in: CGRect(x: mX - mR, y: mY - mR, width: mR * 2, height: mR * 2))
        
        // Cumulus Cloud Banks
        ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: 0.25).cgColor)
        for _ in 0..<4 {
            let cX = CGFloat(rand()) * size.width
            let cY = CGFloat(0.25 + rand() * 0.4) * size.height
            let cR = CGFloat(35 + rand() * 50)
            ctx.fillEllipse(in: CGRect(x: cX - cR, y: cY - cR, width: cR * 2, height: cR * 1.5))
        }
        
        // Torii Shrine Gate
        let gW: CGFloat = 30
        let gH: CGFloat = 42
        let gX = size.width * 0.35
        ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 0.95).cgColor)
        ctx.fill(CGRect(x: gX - gW / 2, y: 0, width: 4, height: gH))
        ctx.fill(CGRect(x: gX + gW / 2 - 4, y: 0, width: 4, height: gH))
        ctx.fill(CGRect(x: gX - gW / 2 - 4, y: gH - 6, width: gW + 8, height: 4))
    }
    
    // MARK: - 7. Abstract (Iridescent Liquid Chrome & Fractal Vortices)
    private func renderAbstractScene(ctx: CGContext, size: CGSize, rand: () -> Double, subVariant: Int, baseHue: Double) {
        for i in 0..<7 {
            let r = CGFloat(20 + rand() * 45)
            let x = CGFloat(rand()) * size.width
            let y = CGFloat(rand()) * size.height
            let orbHue = CGFloat((baseHue + Double(i) * 0.15).truncatingRemainder(dividingBy: 1.0))
            ctx.setFillColor(NSColor(calibratedHue: orbHue, saturation: 0.85, brightness: 0.95, alpha: 0.4).cgColor)
            ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        }
    }
}
