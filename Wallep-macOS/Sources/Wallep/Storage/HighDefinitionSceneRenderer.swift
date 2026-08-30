import Cocoa
import CoreGraphics

public final class HighDefinitionSceneRenderer {
    public static let shared = HighDefinitionSceneRenderer()
    
    private init() {}
    
    public func drawScene(category: WallpaperCategory, size: CGSize, progress: Double, seed: UInt64) -> CGImage? {
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
        ) else { return nil }
        
        var currentSeed = seed
        func rand() -> Double {
            currentSeed = currentSeed &* 6364136223846793005 &+ 1442695040888963407
            return Double((currentSeed >> 32) & 0xFFFFFF) / Double(0xFFFFFF)
        }
        
        // Base dark space canvas
        ctx.setFillColor(NSColor(calibratedWhite: 0.04, alpha: 1.0).cgColor)
        ctx.fill(CGRect(origin: .zero, size: size))
        
        // Render dynamic category layers
        switch category {
        case .cyberpunk:
            // Cityscape skyline with neon glows
            let buildingCount = 10
            let bWidth = size.width / CGFloat(buildingCount)
            for i in 0..<buildingCount {
                let bH = size.height * CGFloat(0.3 + 0.4 * rand())
                ctx.setFillColor(NSColor(calibratedWhite: 0.08, alpha: 1.0).cgColor)
                ctx.fill(CGRect(x: CGFloat(i) * bWidth, y: 0, width: bWidth - 2, height: bH))
                
                // Animated neon accents
                let neonHue = rand() > 0.5 ? 0.85 : 0.52
                let alpha = 0.6 + 0.4 * sin(progress * .pi * 2 + Double(i))
                ctx.setFillColor(NSColor(calibratedHue: CGFloat(neonHue), saturation: 0.95, brightness: 1.0, alpha: CGFloat(alpha)).cgColor)
                ctx.fill(CGRect(x: CGFloat(i) * bWidth + 4, y: bH - 6, width: bWidth - 10, height: 3))
            }
        case .space:
            // Twinkling stars & rotating nebula
            for i in 0..<50 {
                let sX = CGFloat(rand()) * size.width
                let sY = CGFloat(rand()) * size.height
                let sAlpha = 0.3 + 0.7 * sin(progress * .pi * 2 + Double(i))
                ctx.setFillColor(NSColor(calibratedWhite: 1.0, alpha: CGFloat(sAlpha)).cgColor)
                ctx.fillEllipse(in: CGRect(x: sX, y: sY, width: 2, height: 2))
            }
        case .nature:
            // Mountain ridges and ambient light rays
            ctx.setFillColor(NSColor(calibratedRed: 0.05, green: 0.25, blue: 0.18, alpha: 0.8).cgColor)
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: 0, y: size.height * 0.4))
            ctx.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.6))
            ctx.addLine(to: CGPoint(x: size.width, y: size.height * 0.3))
            ctx.addLine(to: CGPoint(x: size.width, y: 0))
            ctx.closePath()
            ctx.fillPath()
        case .cars:
            // Dynamic motion streaks
            for i in 0..<8 {
                let y = size.height * CGFloat(0.2 + 0.6 * rand())
                let isRed = (i % 2 == 0)
                let color = isRed ? NSColor(calibratedRed: 1.0, green: 0.2, blue: 0.1, alpha: 0.85) : NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.1, alpha: 0.85)
                ctx.setStrokeColor(color.cgColor)
                ctx.setLineWidth(3.0)
                let offset = CGFloat(sin(progress * .pi * 2 + Double(i))) * 30.0
                ctx.move(to: CGPoint(x: 0, y: y + offset))
                ctx.addLine(to: CGPoint(x: size.width, y: y + offset))
                ctx.strokePath()
            }
        default:
            // Smooth gradient wave
            let angle = progress * .pi * 2
            let c1 = NSColor(calibratedHue: CGFloat(0.6 + 0.2 * sin(angle)), saturation: 0.8, brightness: 0.7, alpha: 0.5)
            ctx.setFillColor(c1.cgColor)
            ctx.fillEllipse(in: CGRect(x: size.width * 0.2, y: size.height * 0.2, width: size.width * 0.6, height: size.height * 0.6))
        }
        
        return ctx.makeImage()
    }
}
