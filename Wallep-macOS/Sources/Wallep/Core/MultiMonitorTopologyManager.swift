import Cocoa
import Combine

public final class MultiMonitorTopologyManager: ObservableObject {
    public static let shared = MultiMonitorTopologyManager()
    
    @Published public var connectedScreens: [NSScreen] = []
    @Published public var isPanoramaSpanningEnabled: Bool = false
    
    private init() {
        refreshScreens()
        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: nil, queue: .main) { [weak self] _ in
            self?.refreshScreens()
        }
    }
    
    public func refreshScreens() {
        self.connectedScreens = NSScreen.screens
    }
}
