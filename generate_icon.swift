import Cocoa
import CoreGraphics

func generateAppIcon() {
    let size = CGSize(width: 1024, height: 1024)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
    
    guard let context = CGContext(
        data: nil,
        width: Int(size.width),
        height: Int(size.height),
        bitsPerComponent: 8,
        bytesPerRow: Int(size.width) * 4,
        space: colorSpace,
        bitmapInfo: bitmapInfo
    ) else {
        fatalError("Failed to create graphics context")
    }
    
    let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
    NSGraphicsContext.current = graphicsContext
    
    // Apple icon squircle bounding box (824x824 centered in 1024x1024 canvas with standard Apple margins)
    let iconRect = CGRect(x: 100, y: 100, width: 824, height: 824)
    let cornerRadius: CGFloat = 185.0
    let path = NSBezierPath(roundedRect: iconRect, xRadius: cornerRadius, yRadius: cornerRadius)
    
    // Draw deep sleek black background
    NSColor(calibratedRed: 0.05, green: 0.05, blue: 0.07, alpha: 1.0).setFill()
    path.fill()
    
    // Draw subtle Apple-style border stroke
    NSColor(calibratedWhite: 1.0, alpha: 0.12).setStroke()
    path.lineWidth = 4.0
    path.stroke()
    
    // Draw Bold White 'W' in Center
    let text = "W"
    let font = NSFont.systemFont(ofSize: 520, weight: .heavy)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    let textSize = attributedString.size()
    let textRect = CGRect(
        x: (size.width - textSize.width) / 2,
        y: (size.height - textSize.height) / 2 - 15,
        width: textSize.width,
        height: textSize.height
    )
    
    attributedString.draw(in: textRect)
    
    guard let cgImage = context.makeImage() else {
        fatalError("Failed to make CGImage")
    }
    
    let rep = NSBitmapImageRep(cgImage: cgImage)
    guard let pngData = rep.representation(using: .png, properties: [:]) else {
        fatalError("Failed to export PNG data")
    }
    
    let basePNG = URL(fileURLWithPath: "/tmp/AppIcon_1024.png")
    try? pngData.write(to: basePNG)
    print("Base PNG written to /tmp/AppIcon_1024.png")
}

generateAppIcon()
