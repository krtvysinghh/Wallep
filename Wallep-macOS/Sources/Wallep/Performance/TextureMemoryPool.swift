import Cocoa
import Metal

public final class TextureMemoryPool {
    public static let shared = TextureMemoryPool()
    private var pool: [String: MTLTexture] = [:]
    
    private init() {}
    
    public func drain() {
        pool.removeAll()
    }
}
