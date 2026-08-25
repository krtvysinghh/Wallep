import Cocoa
import SwiftUI
import CoreGraphics

public final class WallpaperThumbnailRenderer {
    public static let shared = WallpaperThumbnailRenderer()
    
    private let cache = NSCache<NSString, NSImage>()
    
    private init() {
        cache.countLimit = 300 // Keep up to 300 rendered previews in RAM cache
    }
    
    public func thumbnail(for item: WallpaperItem, size: CGSize = CGSize(width: 360, height: 200)) -> NSImage {
        let cacheKey = NSString(string: "\(item.id)_\(Int(size.width))x\(Int(size.height))")
        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }
        
        // If there's a real local image file, load and cache it
        if !item.thumbnailURL.isEmpty && FileManager.default.fileExists(atPath: item.thumbnailURL),
           let fileImage = NSImage(contentsOfFile: item.thumbnailURL) {
            cache.setObject(fileImage, forKey: cacheKey)
            return fileImage
        }
        
        // Render unique procedural artwork based on item's seed and category
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
        
        // Deterministic pseudo-random seed derived from item ID and Title
        var seed = UInt64(abs(item.id.hashValue ^ item.title.hashValue))
        func nextRandom() -> Double {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            return Double((seed >> 32) & 0xFFFFFF) / Double(0xFFFFFF)
        }
        
        // 1. Draw Base Atmospheric Gradient
        let basePalette = getThemeColors(category: item.category, seedFn: nextRandom)
        let cgColors = basePalette.map { $0.cgColor } as CFArray
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: [0.0, 0.45, 1.0]) {
            let startPoint = CGPoint(x: nextRandom() * Double(width) * 0.4, y: Double(height) * (0.8 + 0.2 * nextRandom()))
            let endPoint = CGPoint(x: Double(width) * (0.6 + 0.4 * nextRandom()), y: 0)
            ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
        
        // 2. Render Category-Specific Generative Visuals
        switch item.category {
        case .cyberpunk:
            renderCyberpunkDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .space:
            renderSpaceDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .nature:
            renderNatureDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .cars:
            renderCarsDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .anime:
            renderAnimeDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .minimalist:
            renderMinimalistDetails(ctx: ctx, size: size, seedFn: nextRandom)
        case .abstract, .all:
            renderAbstractDetails(ctx: ctx, size: size, seedFn: nextRandom)
        }
        
        // 3. Subtle Vignette & Glass Edge
        let vignetteColors = [NSColor.clear.cgColor, NSColor(calibratedWhite: 0.0, alpha: 0.45).cgColor] as CFArray
        if let vGradient = CGGradient(colorsSpace: colorSpace, colors: vignetteColors, locations: [0.4, 1.0]) {
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = max(size.width, size.height) * 0.7
            ctx.drawRadialGradient(vGradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: [])
        }
        
        guard let cgImg = ctx.makeImage() else {
            return NSImage(size: size)
        }
        return NSImage(cgImage: cgImg, size: size)
    }
    
    private func getThemeColors(category: WallpaperCategory, seedFn: () -> Double) -> [NSColor] {
        let h1 = seedFn()
        let s1 = 0.6 + 0.4 * seedFn()
        let b1 = 0.15 + 0.25 * seedFn()
        
        switch category {
        case .cyberpunk:
            return [
                NSColor(calibratedHue: 0.75 + 0.15 * seedFn(), saturation: 0.9, brightness: 0.18, alpha: 1.0),
                NSColor(calibratedHue: 0.85 + 0.1 * seedFn(), saturation: 0.95, brightness: 0.45, alpha: 1.0),
                NSColor(calibratedHue: 0.52 + 0.08 * seedFn(), saturation: 0.95, brightness: 0.75, alpha: 1.0)
            ]
        case .space:
            return [
                NSColor(calibratedHue: 0.65 + 0.1 * seedFn(), saturation: 0.9, brightness: 0.08, alpha: 1.0),
                NSColor(calibratedHue: 0.78 + 0.15 * seedFn(), saturation: 0.85, brightness: 0.35, alpha: 1.0),
                NSColor(calibratedHue: 0.58 + 0.1 * seedFn(), saturation: 0.75, brightness: 0.60, alpha: 1.0)
            ]
        case .nature:
            return [
                NSColor(calibratedHue: 0.38 + 0.1 * seedFn(), saturation: 0.8, brightness: 0.12, alpha: 1.0),
                NSColor(calibratedHue: 0.42 + 0.08 * seedFn(), saturation: 0.85, brightness: 0.40, alpha: 1.0),
                NSColor(calibratedHue: 0.28 + 0.12 * seedFn(), saturation: 0.70, brightness: 0.70, alpha: 1.0)
            ]
        case .cars:
            return [
                NSColor(calibratedHue: 0.0 + 0.05 * seedFn(), saturation: 0.85, brightness: 0.10, alpha: 1.0),
                NSColor(calibratedHue: 0.98 + 0.04 * seedFn(), saturation: 0.90, brightness: 0.50, alpha: 1.0),
                NSColor(calibratedHue: 0.08 + 0.08 * seedFn(), saturation: 0.95, brightness: 0.85, alpha: 1.0)
            ]
        case .anime:
            return [
                NSColor(calibratedHue: 0.60 + 0.1 * seedFn(), saturation: 0.7, brightness: 0.20, alpha: 1.0),
                NSColor(calibratedHue: 0.82 + 0.1 * seedFn(), saturation: 0.65, brightness: 0.60, alpha: 1.0),
                NSColor(calibratedHue: 0.05 + 0.1 * seedFn(), saturation: 0.75, brightness: 0.90, alpha: 1.0)
            ]
        case .minimalist:
            return [
                NSColor(calibratedHue: h1, saturation: 0.3, brightness: 0.15, alpha: 1.0),
                NSColor(calibratedHue: (h1 + 0.2).truncatingRemainder(dividingBy: 1.0), saturation: 0.4, brightness: 0.40, alpha: 1.0),
                NSColor(calibratedHue: (h1 + 0.4).truncatingRemainder(dividingBy: 1.0), saturation: 0.3, brightness: 0.80, alpha: 1.0)
            ]
        case .abstract, .all:
            return [
                NSColor(calibratedHue: h1, saturation: s1, brightness: b1, alpha: 1.0),
                NSColor(calibratedHue: (h1 + 0.3).truncatingRemainder(dividingBy: 1.0), saturation: 0.8, brightness: 0.55, alpha: 1.0),
                NSColor(calibratedHue: (h1 + 0.6).truncatingRemainder(dividingBy: 1.0), saturation: 0.9, brightness: 0.85, alpha: 1.0)
            ]
        }
    }
    
    private func renderCyberpunkDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Neon skyline silhouettes
        let buildingCount = 12 + Int(seedFn() * 8)
        let buildingWidth = size.width / CGFloat(buildingCount)
        
        ctx.setFillColor(NSColor(calibratedWhite: 0.03, alpha: 0.9).cgColor)
        for i in 0..<buildingCount {
            let bH = (0.25 + 0.5 * seedFn()) * size.height
            let bX = CGFloat(i) * buildingWidth
            ctx.fill(CGRect(x: bX, y: 0, width: buildingWidth + 1, height: bH))
            
            // Random illuminated windows
            if seedFn() > 0.3 {
                ctx.setFillColor(NSColor(calibratedHue: seedFn() > 0.5 ? 0.85 : 0.5, saturation: 0.9, brightness: 0.9, alpha: 0.7).cgColor)
                for _ in 0..<3 {
                    let wX = bX + CGFloat(seedFn() * Double(buildingWidth - 4))
                    let wY = CGFloat(seedFn() * Double(bH - 10))
                    ctx.fill(CGRect(x: wX, y: wY, width: 3, height: 4))
                }
                ctx.setFillColor(NSColor(calibratedWhite: 0.03, alpha: 0.9).cgColor)
            }
        }
        
        // Neon grid lines
        ctx.setStrokeColor(NSColor(calibratedRed: 0.0, green: 0.9, blue: 1.0, alpha: 0.35).cgColor)
        ctx.setLineWidth(1.2)
        for i in 0..<5 {
            let y = CGFloat(i) * (size.height * 0.08)
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: size.width, y: y))
            ctx.strokePath()
        }
    }
    
    private func renderSpaceDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Glowing star clusters
        let starCount = 60 + Int(seedFn() * 40)
        for _ in 0..<starCount {
            let x = CGFloat(seedFn()) * size.width
            let y = CGFloat(seedFn()) * size.height
            let r = CGFloat(0.8 + seedFn() * 2.2)
            let alpha = CGFloat(0.4 + seedFn() * 0.6)
            ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: alpha).cgColor)
            ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        }
        
        // Cosmic planetary body
        let planetR = CGFloat(20 + seedFn() * 35)
        let planetX = CGFloat(0.2 + seedFn() * 0.6) * size.width
        let planetY = CGFloat(0.3 + seedFn() * 0.5) * size.height
        
        ctx.setFillColor(NSColor(calibratedHue: seedFn(), saturation: 0.7, brightness: 0.85, alpha: 0.8).cgColor)
        ctx.fillEllipse(in: CGRect(x: planetX - planetR, y: planetY - planetR, width: planetR * 2, height: planetR * 2))
        
        // Planetary Ring
        ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: 0.4).cgColor)
        ctx.setLineWidth(2.5)
        ctx.strokeEllipse(in: CGRect(x: planetX - planetR * 1.8, y: planetY - planetR * 0.5, width: planetR * 3.6, height: planetR))
    }
    
    private func renderNatureDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Mountain silhouettes
        ctx.setFillColor(NSColor(calibratedWhite: 0.05, alpha: 0.8).cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        
        var currentX: CGFloat = 0
        while currentX < size.width {
            let step = CGFloat(30 + seedFn() * 60)
            let peakY = CGFloat(0.2 + seedFn() * 0.4) * size.height
            currentX += step
            ctx.addLine(to: CGPoint(x: currentX, y: peakY))
        }
        ctx.addLine(to: CGPoint(x: size.width, y: 0))
        ctx.closePath()
        ctx.fillPath()
        
        // Sunbeams / God-rays
        ctx.setStrokeColor(NSColor(calibratedHue: 0.12, saturation: 0.4, brightness: 1.0, alpha: 0.18).cgColor)
        ctx.setLineWidth(8)
        let sunX = CGFloat(seedFn()) * size.width
        for i in 0..<5 {
            ctx.move(to: CGPoint(x: sunX, y: size.height))
            let targetX = CGFloat(i) * (size.width / 4)
            ctx.addLine(to: CGPoint(x: targetX, y: 0))
            ctx.strokePath()
        }
    }
    
    private func renderCarsDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // High speed light trails
        ctx.setLineWidth(3.0)
        let trailCount = 6 + Int(seedFn() * 6)
        for i in 0..<trailCount {
            let isRed = (i % 2 == 0)
            let color = isRed ? NSColor(calibratedRed: 1.0, green: 0.15, blue: 0.1, alpha: 0.8) : NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.2, alpha: 0.8)
            ctx.setStrokeColor(color.cgColor)
            
            let startY = CGFloat(0.15 + seedFn() * 0.4) * size.height
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: startY))
            ctx.addCurve(
                to: CGPoint(x: size.width, y: startY + CGFloat((seedFn() - 0.5) * 40)),
                control1: CGPoint(x: size.width * 0.4, y: startY + 20),
                control2: CGPoint(x: size.width * 0.7, y: startY - 20)
            )
            ctx.strokePath()
        }
    }
    
    private func renderAnimeDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Towering cumulus clouds
        ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: 0.25).cgColor)
        for _ in 0..<4 {
            let cX = CGFloat(seedFn()) * size.width
            let cY = CGFloat(0.3 + seedFn() * 0.4) * size.height
            let cR = CGFloat(30 + seedFn() * 50)
            ctx.fillEllipse(in: CGRect(x: cX - cR, y: cY - cR, width: cR * 2, height: cR * 1.5))
        }
        
        // Crescent moon
        let mX = CGFloat(0.75 + seedFn() * 0.15) * size.width
        let mY = CGFloat(0.75 + seedFn() * 0.15) * size.height
        ctx.setFillColor(NSColor(calibratedHue: 0.15, saturation: 0.3, brightness: 1.0, alpha: 0.85).cgColor)
        ctx.fillEllipse(in: CGRect(x: mX, y: mY, width: 22, height: 22))
    }
    
    private func renderMinimalistDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Smooth geometric wave curves
        ctx.setStrokeColor(NSColor(calibratedWhite: 1.0, alpha: 0.25).cgColor)
        ctx.setLineWidth(2.0)
        for i in 0..<4 {
            let y = CGFloat(i) * (size.height * 0.22) + 20
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addCurve(
                to: CGPoint(x: size.width, y: y),
                control1: CGPoint(x: size.width * 0.33, y: y + 40),
                control2: CGPoint(x: size.width * 0.66, y: y - 40)
            )
            ctx.strokePath()
        }
    }
    
    private func renderAbstractDetails(ctx: CGContext, size: CGSize, seedFn: () -> Double) {
        // Fluid ribbon particles
        for _ in 0..<8 {
            ctx.setFillColor(NSColor(calibratedHue: seedFn(), saturation: 0.8, brightness: 0.9, alpha: 0.3).cgColor)
            let r = CGFloat(15 + seedFn() * 40)
            let x = CGFloat(seedFn()) * size.width
            let y = CGFloat(seedFn()) * size.height
            ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
        }
    }
}
