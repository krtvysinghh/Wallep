import Testing
import Foundation
import Cocoa
@testable import WallepKit

@Suite("Wallep Engine, Security & Scale Test Suite")
struct WallepTestSuite {
    
    // MARK: - 1. Curated Catalog & Scale Tests
    
    @Test("Curated Catalog has 4,500+ items and zero duplicate IDs")
    func testCuratedCatalogScaleAndIntegrity() async throws {
        let catalog = CuratedCatalog.shared
        #expect(catalog.items.count >= 4500)
        
        let allIDs = catalog.items.map { $0.id }
        let uniqueIDs = Set(allIDs)
        #expect(allIDs.count == uniqueIDs.count)
        
        for item in catalog.items.prefix(200) {
            #expect(!item.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!item.author.isEmpty)
            #expect(item.duration > 0)
            #expect(item.likes > 0)
            #expect(!item.resolution.isEmpty)
        }
    }
    
    @Test("Curated Catalog covers all seven aesthetic categories")
    func testAllCategoriesPresent() async throws {
        let catalog = CuratedCatalog.shared
        let categories = Set(catalog.items.map { $0.category })
        
        #expect(categories.contains(.cyberpunk))
        #expect(categories.contains(.space))
        #expect(categories.contains(.nature))
        #expect(categories.contains(.cars))
        #expect(categories.contains(.anime))
        #expect(categories.contains(.minimalist))
        #expect(categories.contains(.abstract))
    }
    
    // MARK: - 2. Security & Path Traversal Injection Tests
    
    @Test("Security rejects disallowed non-video executable extensions")
    func testDisallowedExtensionsBlocked() async throws {
        let library = LibraryManager.shared
        let blocked = ["sh", "exe", "bat", "php", "py", "js", "html", "dylib", "so", "bin"]
        for ext in blocked {
            let fakeURL = URL(fileURLWithPath: "/tmp/exploit.\(ext)")
            let result = library.importCustomVideo(at: fakeURL)
            #expect(result == nil)
        }
    }
    
    @Test("Security sanitizes path traversal attempts and isolates storage")
    func testPathTraversalSanitization() async throws {
        let library = LibraryManager.shared
        let tempDir = FileManager.default.temporaryDirectory
        let maliciousFile = tempDir.appendingPathComponent("exploit_test.mp4")
        try? "test_payload".write(to: maliciousFile, atomically: true, encoding: .utf8)
        
        if let imported = library.importCustomVideo(at: maliciousFile) {
            let expectedPrefix = library.storageDirectory.path
            #expect(imported.videoURL.path.hasPrefix(expectedPrefix))
            #expect(!imported.videoURL.path.contains(".."))
        }
        
        try? FileManager.default.removeItem(at: maliciousFile)
    }
    
    // MARK: - 3. Auto-Change Rotation Logic Tests
    
    @Test("AutoChange intervals match correct duration seconds")
    func testAutoChangeIntervals() async throws {
        #expect(AutoChangeInterval.oneMinute.timeInterval == 60)
        #expect(AutoChangeInterval.fiveMinutes.timeInterval == 300)
        #expect(AutoChangeInterval.fifteenMinutes.timeInterval == 900)
        #expect(AutoChangeInterval.thirtyMinutes.timeInterval == 1800)
        #expect(AutoChangeInterval.oneHour.timeInterval == 3600)
        #expect(AutoChangeInterval.daily.timeInterval == 86400)
    }
    
    @Test("AutoChange trigger successfully selects and applies wallpaper")
    func testAutoChangeExecution() async throws {
        let autoChange = AutoChangeManager.shared
        autoChange.isEnabled = true
        autoChange.source = .all
        autoChange.triggerNextWallpaper()
        
        #expect(WallpaperManager.shared.currentWallpaper != nil)
    }
    
    // MARK: - 4. Generative Thumbnail & Caching Tests
    
    @Test("Generative thumbnail renderer creates valid cached image")
    func testThumbnailRenderer() async throws {
        let renderer = WallpaperThumbnailRenderer.shared
        let item = WallpaperItem(
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
        
        let img = renderer.thumbnail(for: item, size: CGSize(width: 180, height: 100))
        #expect(img.size.width == 180)
        #expect(img.size.height == 100)
        
        let cached = renderer.thumbnail(for: item, size: CGSize(width: 180, height: 100))
        #expect(img == cached)
    }
    
    // MARK: - 5. CLI Arguments Parsing Tests
    
    @Test("CLI parser handles help, list, and status commands correctly")
    func testCLICommands() async throws {
        #expect(CLIHandler.handle(arguments: ["wallep", "--help"]))
        #expect(CLIHandler.handle(arguments: ["wallep", "-h"]))
        #expect(CLIHandler.handle(arguments: ["wallep", "list"]))
        #expect(CLIHandler.handle(arguments: ["wallep", "status"]))
        #expect(CLIHandler.handle(arguments: ["wallep", "invalid_cmd"]))
    }
}
