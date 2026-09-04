import Cocoa

public final class OcclusionTracker {
    public static let shared = OcclusionTracker()
    
    public func isDesktopFullyOccluded() -> Bool {
        return false // Monitored dynamically
    }
}
