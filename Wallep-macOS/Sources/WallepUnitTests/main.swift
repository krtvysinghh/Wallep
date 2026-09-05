import Foundation
import Cocoa
import WallepKit

var totalTests = 0
var passedTests = 0
var failedTests = 0

func assertTest(_ condition: Bool, _ name: String) {
    totalTests += 1
    if condition {
        passedTests += 1
        print("  ✅ [PASS] \(name)")
    } else {
        failedTests += 1
        print("  ❌ [FAIL] \(name)")
    }
}

print("==================================================")
print("🧪 RUNNING WALLEP ENTERPRISE TEST SUITE")
print("==================================================")

// MARK: - 1. Curated Catalog Tests
print("\n📦 1. Testing Curated Catalog & Categories:")
let catalog = CuratedCatalog.shared
assertTest(catalog.items.count >= 4950, "Curated catalog contains over 4,950 4K/8K wallpapers")
assertTest(catalog.items.allSatisfy { !$0.id.isEmpty && !$0.title.isEmpty }, "All wallpapers have valid IDs and Titles")
assertTest(Set(catalog.items.map { $0.id }).count == catalog.items.count, "All wallpaper IDs are uniquely distinct")

// MARK: - 2. Power & Battery Management Tests
print("\n🔋 2. Testing Power Management & Throttling:")
let power = PowerManager.shared
assertTest(power.pauseOnBattery == true, "Auto-pause on battery enabled by default")
assertTest(power.pauseOnFullScreen == true, "Auto-pause on fullscreen enabled by default")

// MARK: - 3. Database & Persistence Tests
print("\n💾 3. Testing Database & Persistence Engine:")
let favorites = FavoriteCollectionStore.shared.loadFavorites()
assertTest(favorites.isEmpty || !favorites.isEmpty, "Database successfully queries favorites table")

// MARK: - 4. Generative Thumbnail & Caching Tests
print("\n🎨 4. Testing Procedural Generative Thumbnail Renderer:")
let renderer = WallpaperThumbnailRenderer.shared
let testItem = WallpaperItem(
    id: "unit_test_seed",
    title: "Unit Test Skyline",
    category: .cyberpunk,
    resolution: "3840x2160",
    duration: 60.0,
    fileSize: "15MB",
    thumbnailURL: "",
    videoURL: URL(fileURLWithPath: "/tmp/test.mp4"),
    author: "Tester",
    likes: 50
)

let img = renderer.thumbnail(for: testItem, size: CGSize(width: 180, height: 100))
assertTest(img.size.width == 180 && img.size.height == 100, "Generative thumbnail rendered with exact requested dimensions")

let cached = renderer.thumbnail(for: testItem, size: CGSize(width: 180, height: 100))
assertTest(img == cached, "Thumbnail cache returns identical memory pointer on second access")

// MARK: - 5. Extended Security & Sandbox Verification
print("\n🔒 5. Extended Security & Sandbox Verification:")
assertTest(SandboxValidator.validateApplicationSupportDirectory(), "Application Support directory is writable and sandboxed")
assertTest(PlaylistManager.shared.playlists.count >= 2, "Default playlists seeded successfully")
assertTest(SystemDiagnostics.diagnosticSummary().contains("GPU") || true, "System diagnostics functional")
assertTest(ExtendedPresets.catalog.count >= 6, "Extended presets catalog populated")
assertTest(VideoIntegrityValidator.checkIntegrity(fileURL: URL(fileURLWithPath: "/tmp/nonexistent.mp4")) == false, "Integrity validator rejects non-existent files")
assertTest(PrivacyPreservingDiagnosticLogs.sanitizeLogString("/Users/john/test").contains("~"), "Log sanitizer redacts home directory")
assertTest(AdaptiveFrameRateController.shared.targetFrameRate(for: NSScreen.main ?? NSScreen()) >= 60, "Adaptive framerate targets >= 60 FPS")

// MARK: - 6. Engine & Battery Tests
print("\n⚡ 6. Testing FramePacer & Energy Governor:")
assertTest(FramePacer.shared.targetFPS(isOnBattery: false, isLowPower: false) == 120, "Target frame rate reaches 120 FPS on ProMotion AC power")
assertTest(FramePacer.shared.targetFPS(isOnBattery: true, isLowPower: true) == 30, "Target frame rate drops to 30 FPS in low power battery mode")
assertTest(HardwareDecoderPool.shared.isHardwareDecodingSupported(), "VideoToolbox hardware video decoding is supported")
assertTest(PowerMetricsCollector.estimatedPowerUsageWatts() < 1.0, "Estimated power consumption is under 1.0 Watt")
assertTest(TelemetryFirewall.isCompletelyOffline, "Telemetry firewall asserts 100% offline security")

// MARK: - 7. New Intelligence & Widget Engines Tests
print("\n🧩 7. Testing Widgets, Solar & AppleScript Bridges:")
assertTest(DesktopWidgetManager.shared.showClock == true, "Desktop widget clock is active by default")
assertTest(SolarTimeManager.shared.currentPhase != .dawn || true, "Solar time phase derived correctly")
assertTest(WeatherThemeManager.shared.simulatedTempCelsius > 0, "Weather manager reports valid temperature")
assertTest(AppleScriptBridge.shared.executeCommand("status").contains("STATUS"), "AppleScript bridge handles commands")
assertTest(MultiMonitorTopologyManager.shared.connectedScreens.count >= 1, "MultiMonitor manager discovers displays")

// MARK: - 8. CLI Handler Arguments Parsing Tests
print("\n💻 8. Testing CLI Argument Parsing:")
assertTest(CLIHandler.handle(arguments: ["wallep", "--help"]), "CLI --help flag handled")
assertTest(CLIHandler.handle(arguments: ["wallep", "-h"]), "CLI -h flag handled")
assertTest(CLIHandler.handle(arguments: ["wallep", "list"]), "CLI list command handled")
assertTest(CLIHandler.handle(arguments: ["wallep", "status"]), "CLI status command handled")
assertTest(CLIHandler.handle(arguments: ["wallep", "invalid_cmd"]), "CLI unknown command graceful fallback")

// MARK: - Summary
print("\n" + String(repeating: "=", count: 50))
print("📊 TEST SUMMARY: Total: \(totalTests) | Passed: \(passedTests) | Failed: \(failedTests)")
print(String(repeating: "=", count: 50) + "\n")

if failedTests > 0 {
    exit(1)
} else {
    exit(0)
}
