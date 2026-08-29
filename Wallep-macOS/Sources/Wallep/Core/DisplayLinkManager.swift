import Cocoa
import QuartzCore

public final class DisplayLinkManager {
    public static let shared = DisplayLinkManager()
    
    private var displayLink: CVDisplayLink?
    private var isRunning: Bool = false
    
    private init() {
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
    }
    
    deinit {
        stop()
    }
    
    public func start(callback: @escaping () -> Void) {
        guard let link = displayLink, !isRunning else { return }
        CVDisplayLinkStart(link)
        isRunning = true
    }
    
    public func stop() {
        guard let link = displayLink, isRunning else { return }
        CVDisplayLinkStop(link)
        isRunning = false
    }
}
