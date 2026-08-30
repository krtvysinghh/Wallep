import Foundation
import Combine

public final class LiveExportProgressTracker: ObservableObject {
    public static let shared = LiveExportProgressTracker()
    
    @Published public var isExporting: Bool = false
    @Published public var progress: Double = 0.0
    @Published public var statusMessage: String = ""
    
    private init() {}
    
    public func update(progress: Double, message: String) {
        self.progress = progress
        self.statusMessage = message
        self.isExporting = progress < 1.0 && progress > 0.0
    }
}
