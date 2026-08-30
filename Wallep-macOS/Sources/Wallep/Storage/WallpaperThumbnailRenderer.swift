import Cocoa
import SwiftUI
import CoreGraphics

public final class WallpaperThumbnailRenderer {
    public static let shared = WallpaperThumbnailRenderer()
    
    private let cache = NSCache<NSString, NSImage>()
    
    private init() {
        cache.countLimit = 500
    }
    
    public func thumbnail(for item: WallpaperItem, size: CGSize = CGSize(width: 360, height: 200)) -> NSImage {
        let cacheKey = NSString(string: "\(item.id)_\(Int(size.width))x\(Int(size.height))")
        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }
        
        // If there's a real local image file on disk, load and cache it
        if !item.thumbnailURL.isEmpty && FileManager.default.fileExists(atPath: item.thumbnailURL),
           let fileImage = NSImage(contentsOfFile: item.thumbnailURL) {
            cache.setObject(fileImage, forKey: cacheKey)
            return fileImage
        }
        
        // Render unique, vibrant procedural artwork based on stable seed
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
        
        // Deterministic 64-bit FNV-1a hash
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
        
        // 1. Base Multi-Stop Vibrant Sky Gradient
        let primaryHue = rand()
        let secondaryHue = (primaryHue + 0.25 + 0.5 * rand()).truncatingRemainder(dividingBy: 1.0)
        let tertiaryHue = (secondaryHue + 0.2 + 0.3 * rand()).truncatingRemainder(dividingBy: 1.0)
        
        let c1 = NSColor(calibratedHue: CGFloat(primaryHue), saturation: CGFloat(0.75 + 0.25 * rand()), brightness: CGFloat(0.12 + 0.18 * rand()), alpha: 1.0)
        let c2 = NSColor(calibratedHue: CGFloat(secondaryHue), saturation: CGFloat(0.80 + 0.20 * rand()), brightness: CGFloat(0.35 + 0.30 * rand()), alpha: 1.0)
        let c3 = NSColor(calibratedHue: CGFloat(tertiaryHue), saturation: CGFloat(0.85 + 0.15 * rand()), brightness: CGFloat(0.70 + 0.25 * rand()), alpha: 1.0)
        
        let gradientColors = [c1.cgColor, c2.cgColor, c3.cgColor] as CFArray
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: [0.0, 0.55, 1.0]) {
            let start = CGPoint(x: CGFloat(rand()) * size.width, y: size.height)
            let end = CGPoint(x: CGFloat(rand()) * size.width, y: 0)
            ctx.drawLinearGradient(gradient, start: start, end: end, options: [])
        }
        
        // 2. Render Distinct Visual Geometry
        switch item.category {
        case .cyberpunk:
            renderCyberpunkMetropolis(ctx: ctx, size: size, rand: rand, baseHue: primaryHue)
        case .space:
            renderCosmicNebula(ctx: ctx, size: size, rand: rand, baseHue: secondaryHue)
        case .nature:
            renderAlpineNature(ctx: ctx, size: size, rand: rand, baseHue: primaryHue)
        case .cars:
            renderMotorsportSpeedway(ctx: ctx, size: size, rand: rand, baseHue: tertiaryHue)
        case .anime:
            renderAnimeTwilight(ctx: ctx, size: size, rand: rand, baseHue: secondaryHue)
        case .minimalist:
            renderMinimalistPrism(ctx: ctx, size: size, rand: rand, baseHue: primaryHue)
        case .abstract, .all:
            renderAbstractFluid(ctx: ctx, size: size, rand: rand, baseHue: primaryHue)
        }
        
        // 3. Subtle Vignette
        let vigColors = [NSColor.clear.cgColor, NSColor(calibratedWhite: 0.0, alpha: 0.4).cgColor] as CFArray
        if let vig = CGGradient(colorsSpace: colorSpace, colors: vigColors, locations: [0.5, 1.0]) {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            ctx.drawRadialGradient(vig, startCenter: center, startRadius: 0, endCenter: center, endRadius: max(size.width, size.height) * 0.75, options: [])
        }
        
        guard let cgImg = ctx.makeImage() else {
            return NSImage(size: size)
        }
        return NSImage(cgImage: cgImg, size: size)
    }
    
    // MARK: - Cyberpunk
    private func renderCyberpunkMetropolis(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Neon Sky Grid
        ctx.setStrokeColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.9, brightness: 1.0, alpha: 0.25).cgColor)
        ctx.setLineWidth(1.0)
        for i in 0..<6 {
            let y = CGFloat(i) * (size.height * 0.07)
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: size.width, y: y))
            ctx.strokePath()
        }
        
        // Multi-layered Skyline Silhouettes
        let layers = 2
        for l in 0..<layers {
            let bCount = 8 + Int(rand() * 8)
            let bWidth = size.width / CGFloat(bCount)
            let alpha = (l == 0) ? 0.5 : 0.9
            ctx.setFillColor(NSColor(calibratedWhite: l == 0 ? 0.08 : 0.03, alpha: CGFloat(alpha)).cgColor)
            
            for i in 0..<bCount {
                let bH = (0.2 + 0.5 * rand()) * size.height * (l == 0 ? 0.8 : 1.0)
                let bX = CGFloat(i) * bWidth
                ctx.fill(CGRect(x: bX, y: 0, width: bWidth - 1, height: bH))
                
                // Holographic Window Clusters & Rooftop Antennas
                if l == 1 && rand() > 0.25 {
                    let winHue = rand() > 0.5 ? (baseHue + 0.3).truncatingRemainder(dividingBy: 1.0) : (baseHue + 0.7).truncatingRemainder(dividingBy: 1.0)
                    ctx.setFillColor(NSColor(calibratedHue: CGFloat(winHue), saturation: 0.95, brightness: 1.0, alpha: 0.85).cgColor)
                    
                    let winCount = 2 + Int(rand() * 4)
                    for _ in 0..<winCount {
                        let wX = bX + CGFloat(rand() * Double(bWidth - 6)) + 2
                        let wY = CGFloat(rand() * Double(bH - 12)) + 4
                        ctx.fill(CGRect(x: wX, y: wY, width: 3, height: 4))
                    }
                    
                    // Antenna with beacon
                    ctx.fill(CGRect(x: bX + bWidth / 2 - 0.5, y: bH, width: 1.5, height: 12))
                    ctx.fillEllipse(in: CGRect(x: bX + bWidth / 2 - 2, y: bH + 11, width: 4, height: 4))
                    ctx.setFillColor(NSColor(calibratedWhite: 0.03, alpha: 0.9).cgColor)
                }
            }
        }
    }
    
    // MARK: - Space
    private func renderCosmicNebula(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Starfield with twinkle
        let starCount = 70 + Int(rand() * 50)
        for _ in 0..<starCount {
            let sX = CGFloat(rand()) * size.width
            let sY = CGFloat(rand()) * size.height
            let sR = CGFloat(0.5 + rand() * 2.0)
            let sA = CGFloat(0.3 + rand() * 0.7)
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: sA).cgColor)
            ctx.fillEllipse(in: CGRect(x: sX - sR, y: sY - sR, width: sR * 2, height: sR * 2))
        }
        
        // Massive Ringed Exoplanet
        let pR = CGFloat(25 + rand() * 45)
        let pX = CGFloat(0.2 + 0.6 * rand()) * size.width
        let pY = CGFloat(0.3 + 0.5 * rand()) * size.height
        
        let planetHue = CGFloat(baseHue)
        ctx.setFillColor(NSColor(calibratedHue: planetHue, saturation: 0.85, brightness: 0.9, alpha: 0.95).cgColor)
        ctx.fillEllipse(in: CGRect(x: pX - pR, y: pY - pR, width: pR * 2, height: pR * 2))
        
        // Slanted Orbit Ring
        ctx.setStrokeColor(NSColor(calibratedHue: planetHue, saturation: 0.4, brightness: 1.0, alpha: 0.6).cgColor)
        ctx.setLineWidth(3.0)
        ctx.strokeEllipse(in: CGRect(x: pX - pR * 1.9, y: pY - pR * 0.45, width: pR * 3.8, height: pR * 0.9))
    }
    
    // MARK: - Nature
    private func renderAlpineNature(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Layered Mountain Ranges
        for layer in 0..<3 {
            let alpha = 0.4 + Double(layer) * 0.25
            ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.6, brightness: CGFloat(0.08 + Double(layer) * 0.06), alpha: CGFloat(alpha)).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: 0))
            
            var curX: CGFloat = 0
            while curX <= size.width {
                let peakY = CGFloat(0.15 + Double(layer) * 0.12 + rand() * 0.25) * size.height
                curX += CGFloat(25 + rand() * 40)
                ctx.addLine(to: CGPoint(x: curX, y: peakY))
            }
            ctx.addLine(to: CGPoint(x: size.width, y: 0))
            ctx.closePath()
            ctx.fillPath()
        }
        
        // Sun / Moon on Horizon
        let sunR = CGFloat(18 + rand() * 16)
        let sunX = CGFloat(0.2 + 0.6 * rand()) * size.width
        let sunY = CGFloat(0.55 + 0.3 * rand()) * size.height
        ctx.setFillColor(NSColor(calibratedHue: CGFloat((baseHue + 0.15).truncatingRemainder(dividingBy: 1.0)), saturation: 0.4, brightness: 1.0, alpha: 0.9).cgColor)
        ctx.fillEllipse(in: CGRect(x: sunX - sunR, y: sunY - sunR, width: sunR * 2, height: sunR * 2))
    }
    
    // MARK: - Cars
    private func renderMotorsportSpeedway(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Horizon light streaks & asphalt reflections
        let count = 8 + Int(rand() * 6)
        for i in 0..<count {
            let isRed = (i % 2 == 0)
            let color = isRed ? NSColor(calibratedRed: 1.0, green: 0.15, blue: 0.1, alpha: 0.85) : NSColor(calibratedRed: 0.1, green: 0.85, blue: 1.0, alpha: 0.85)
            ctx.setStrokeColor(color.cgColor)
            ctx.setLineWidth(CGFloat(2.0 + rand() * 3.0))
            
            let startY = CGFloat(0.1 + rand() * 0.45) * size.height
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: startY))
            ctx.addCurve(
                to: CGPoint(x: size.width, y: startY + CGFloat((rand() - 0.5) * 60)),
                control1: CGPoint(x: size.width * 0.35, y: startY + 30),
                control2: CGPoint(x: size.width * 0.70, y: startY - 30)
            )
            ctx.strokePath()
        }
    }
    
    // MARK: - Anime
    private func renderAnimeTwilight(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Fluffy cumulus cloud banks
        ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.3, brightness: 1.0, alpha: 0.3).cgColor)
        for _ in 0..<5 {
            let cX = CGFloat(rand()) * size.width
            let cY = CGFloat(0.25 + rand() * 0.45) * size.height
            let cR = CGFloat(35 + rand() * 45)
            ctx.fillEllipse(in: CGRect(x: cX - cR, y: cY - cR, width: cR * 2, height: cR * 1.5))
        }
        
        // Torii gate silhouette or shrine spire
        let gW: CGFloat = 32
        let gH: CGFloat = 48
        let gX = CGFloat(0.3 + 0.4 * rand()) * size.width
        let gY: CGFloat = 0
        ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 0.95).cgColor)
        ctx.fill(CGRect(x: gX - gW / 2, y: gY, width: 4, height: gH))
        ctx.fill(CGRect(x: gX + gW / 2 - 4, y: gY, width: 4, height: gH))
        ctx.fill(CGRect(x: gX - gW / 2 - 6, y: gY + gH - 8, width: gW + 12, height: 5))
        ctx.fill(CGRect(x: gX - gW / 2 - 2, y: gY + gH - 18, width: gW + 4, height: 4))
    }
    
    // MARK: - Minimalist
    private func renderMinimalistPrism(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Geometric Arch & Solar Corona
        let archW: CGFloat = 70
        let archH: CGFloat = 110
        let archX = (size.width - archW) / 2
        
        ctx.setFillColor(NSColor(calibratedHue: CGFloat(baseHue), saturation: 0.4, brightness: 0.9, alpha: 0.35).cgColor)
        ctx.fillEllipse(in: CGRect(x: archX, y: 30, width: archW, height: archH))
        
        ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: 0.4).cgColor)
        ctx.setLineWidth(2.0)
        ctx.strokeEllipse(in: CGRect(x: archX, y: 30, width: archW, height: archH))
    }
    
    // MARK: - Abstract
    private func renderAbstractFluid(ctx: CGContext, size: CGSize, rand: () -> Double, baseHue: Double) {
        // Iridescent Ribbon Orbs
        for _ in 0..<6 {
            let r = CGFloat(20 + rand() * 45)
            let x = CGFloat(rand()) * size.width
            let y = CGFloat(rand()) * size.height
            let orbHue = CGFloat((baseHue + rand() * 0.4).truncatingRemainder(dividingBy: 1.0))
            ctx.setFillColor(NSColor(calibratedHue: orbHue, saturation: 0.85, brightness: 0.95, alpha: 0.4).cgColor)
            ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        }
    }
}
