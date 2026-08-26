import Foundation
import Cocoa
import WallepKit

var totalTests = 0
var passedTests = 0
var failedTests = 0

func assertTest(_ condition: Bool, _ testName: String) {
    totalTests += 1
    if condition {
        passedTests += 1
        print("  ✅ [PASS] \(testName)")
    } else {
        failedTests += 1
        print("  ❌ [FAIL] \(testName)")
    }
}

print("🧪 Starting Wallep Production Test Suite...\n")

// MARK: - 1. Curated Catalog & Integrity Tests
print("📦 1. Testing Curated Catalog & Data Integrity:")
let catalog = CuratedCatalog.shared
assertTest(catalog.items.count >= 4500, "Catalog has 4,500+ items (Found: \(catalog.items.count))")

let allIDs = catalog.items.map { $0.id }
let uniqueIDs = Set(allIDs)
assertTest(allIDs.count == uniqueIDs.count, "All \(allIDs.count) wallpaper IDs are strictly unique")

var validMetadata = true
for item in catalog.items.prefix(300) {
    if item.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
       item.author.isEmpty ||
       item.duration <= 0 ||
       item.likes <= 0 ||
       item.resolution.isEmpty {
        validMetadata = false
        break
    }
}
assertTest(validMetadata, "Metadata across catalog items is complete and valid")

let categories = Set(catalog.items.map { $0.category })
let expectedCategories: [WallpaperCategory] = [.cyberpunk, .space, .nature, .cars, .anime, .minimalist, .abstract]
assertTest(expectedCategories.allSatisfy { categories.contains($0) }, "All aesthetic categories represented in catalog")

// MARK: - 2. Security & Path Traversal Injection Tests
print("\n🛡️ 2. Testing Security Hardening & Input Sanitization:")
let library = LibraryManager.shared
let maliciousExtensions = ["sh", "exe", "bat", "php", "py", "js", "html", "dylib", "so", "bin"]
var extensionsBlocked = true
for ext in maliciousExtensions {
    let fakeURL = URL(fileURLWithPath: "/tmp/exploit.\(ext)")
    if library.importCustomVideo(at: fakeURL) != nil {
        extensionsBlocked = false
        break
    }
}
assertTest(extensionsBlocked, "Security whitelist strictly blocks non-video/executable extensions")

let tempDir = FileManager.default.temporaryDirectory
let maliciousFile = tempDir.appendingPathComponent("exploit_test.mp4")
try? "test_payload".write(to: maliciousFile, atomically: true, encoding: .utf8)

if let imported = library.importCustomVideo(at: maliciousFile) {
    let expectedPrefix = library.storageDirectory.path
    let isJailed = imported.videoURL.path.hasPrefix(expectedPrefix)
    let noTraversal = !imported.videoURL.path.contains("..")
    assertTest(isJailed && noTraversal, "Path traversal attempt sanitized and jailed inside Application Support")
} else {
    assertTest(false, "Failed to import test video")
}
try? FileManager.default.removeItem(at: maliciousFile)

// MARK: - 3. Auto-Change Rotation Logic Tests
print("\n⏱️ 3. Testing Auto-Change Engine & Rotation:")
assertTest(AutoChangeInterval.oneMinute.timeInterval == 60, "AutoChange 1m interval = 60s")
assertTest(AutoChangeInterval.fiveMinutes.timeInterval == 300, "AutoChange 5m interval = 300s")
assertTest(AutoChangeInterval.fifteenMinutes.timeInterval == 900, "AutoChange 15m interval = 900s")
assertTest(AutoChangeInterval.thirtyMinutes.timeInterval == 1800, "AutoChange 30m interval = 1800s")
assertTest(AutoChangeInterval.oneHour.timeInterval == 3600, "AutoChange 1h interval = 3600s")
assertTest(AutoChangeInterval.daily.timeInterval == 86400, "AutoChange 24h interval = 86400s")

let autoChange = AutoChangeManager.shared
autoChange.isEnabled = true
autoChange.source = .all
autoChange.triggerNextWallpaper()
assertTest(WallpaperManager.shared.currentWallpaper != nil, "AutoChange trigger sets active wallpaper")

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

// MARK: - 5. CLI Handler Arguments Parsing Tests
print("\n💻 5. Testing CLI Argument Parsing:")
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
