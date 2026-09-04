import Metal
import QuartzCore
import Cocoa

public final class MetalCanvasLayer: CAMetalLayer {
    public override init() {
        super.init()
        self.device = MTLCreateSystemDefaultDevice()
        self.pixelFormat = .bgra8Unorm
        self.framebufferOnly = true
        self.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
