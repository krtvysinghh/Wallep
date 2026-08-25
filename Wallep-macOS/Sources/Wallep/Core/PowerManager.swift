import Cocoa
import IOKit.ps

public protocol PowerManagerDelegate: AnyObject {
    func powerStateDidChange(isOnBattery: Bool, isLowPowerMode: Bool)
    func systemWillSleep()
    func systemDidWake()
    func activeAppDidChange(isFullScreenAppActive: Bool)
}

public final class PowerManager: ObservableObject {
    public static let shared = PowerManager()
    
    public weak var delegate: PowerManagerDelegate?
    
    @Published public var isOnBattery: Bool = false
    @Published public var isLowPowerMode: Bool = false
    @Published public var pauseOnBattery: Bool = true
    @Published public var pauseOnFullScreen: Bool = true
    @Published public var isSystemSleeping: Bool = false
    
    private var powerRunLoopSource: CFRunLoopSource?
    
    private init() {
        checkCurrentPowerSource()
        setupSleepWakeObservers()
        setupAppSwitchObservers()
        setupIOKitPowerSourceCallback()
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        if let source = powerRunLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .defaultMode)
        }
    }
    
    public func checkCurrentPowerSource() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else {
            self.isOnBattery = false
            return
        }
        
        var batteryDetected = false
        for source in sources {
            if let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] {
                if let state = description[kIOPSPowerSourceStateKey as String] as? String {
                    if state == (kIOPSBatteryPowerValue as String) {
                        batteryDetected = true
                        break
                    }
                }
            }
        }
        
        self.isOnBattery = batteryDetected
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        
        delegate?.powerStateDidChange(isOnBattery: self.isOnBattery, isLowPowerMode: self.isLowPowerMode)
    }
    
    private func setupSleepWakeObservers() {
        let wsCenter = NSWorkspace.shared.notificationCenter
        
        // System sleep notification
        wsCenter.addObserver(
            self,
            selector: #selector(handleWillSleep),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )
        
        // System wake notification
        wsCenter.addObserver(
            self,
            selector: #selector(handleDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
        
        // Low Power Mode notification (macOS 12+)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePowerModeChange),
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )
    }
    
    private func setupAppSwitchObservers() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(handleAppActivation(_:)),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
    }
    
    private func setupIOKitPowerSourceCallback() {
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        let loopSource = IOPSNotificationCreateRunLoopSource({ context in
            guard let context = context else { return }
            let manager = Unmanaged<PowerManager>.fromOpaque(context).takeUnretainedValue()
            DispatchQueue.main.async {
                manager.checkCurrentPowerSource()
            }
        }, context)?.takeRetainedValue()
        
        if let loopSource = loopSource {
            self.powerRunLoopSource = loopSource
            CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSource, .defaultMode)
        }
    }
    
    @objc private func handleWillSleep() {
        self.isSystemSleeping = true
        delegate?.systemWillSleep()
    }
    
    @objc private func handleDidWake() {
        self.isSystemSleeping = false
        checkCurrentPowerSource()
        delegate?.systemDidWake()
    }
    
    @objc private func handlePowerModeChange() {
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        delegate?.powerStateDidChange(isOnBattery: self.isOnBattery, isLowPowerMode: self.isLowPowerMode)
    }
    
    @objc private func handleAppActivation(_ notification: Notification) {
        guard pauseOnFullScreen else { return }
        
        // Check if the newly focused application window is in native fullscreen mode
        if let frontApp = NSWorkspace.shared.frontmostApplication {
            let bundleID = frontApp.bundleIdentifier ?? ""
            // Finder or Desktop clicks should never count as fullscreen occlusion
            if bundleID == "com.apple.finder" {
                delegate?.activeAppDidChange(isFullScreenAppActive: false)
                return
            }
            
            // Check window levels using CGWindowListCopyWindowInfo
            let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
            if let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] {
                var isFullScreen = false
                let mainBounds = NSScreen.main?.frame ?? .zero
                
                for window in windowListInfo {
                    if let pid = window[kCGWindowOwnerPID as String] as? pid_t, pid == frontApp.processIdentifier {
                        if let boundsDict = window[kCGWindowBounds as String] as? [String: Any],
                           let w = boundsDict["Width"] as? CGFloat,
                           let h = boundsDict["Height"] as? CGFloat {
                            if abs(w - mainBounds.width) < 5 && abs(h - mainBounds.height) < 5 {
                                isFullScreen = true
                                break
                            }
                        }
                    }
                }
                delegate?.activeAppDidChange(isFullScreenAppActive: isFullScreen)
            }
        }
    }
}
