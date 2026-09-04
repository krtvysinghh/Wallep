import Metal

public final class MetalBufferRecycler {
    public static let shared = MetalBufferRecycler()
    
    private init() {}
    
    public func recycle() {
        // Frees transient Metal buffers
    }
}
