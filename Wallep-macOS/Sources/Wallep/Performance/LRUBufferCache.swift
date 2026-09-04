import Foundation

public final class LRUBufferCache<K: Hashable, V> {
    private let limit: Int
    private var cache: [K: V] = [:]
    private var keys: [K] = []
    
    public init(limit: Int = 100) {
        self.limit = limit
    }
    
    public func set(_ value: V, for key: K) {
        if cache[key] == nil {
            keys.append(key)
        }
        cache[key] = value
        if keys.count > limit {
            let evicted = keys.removeFirst()
            cache.removeValue(forKey: evicted)
        }
    }
    
    public func get(_ key: K) -> V? {
        return cache[key]
    }
}
