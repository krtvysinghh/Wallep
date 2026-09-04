import Foundation

public final class LowMemoryPressureHandler {
    public static let shared = LowMemoryPressureHandler()
    
    public func registerMemoryWarning(callback: @escaping () -> Void) {
        let source = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical], queue: .main)
        source.setEventHandler(handler: callback)
        source.resume()
    }
}
