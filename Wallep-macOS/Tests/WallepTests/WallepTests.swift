import Testing
@testable import Wallep

struct WallepTests {
    @Test func libraryDefaultWallpapers() async throws {
        let library = LibraryManager.shared
        #expect(library.wallpapers.count > 0)
    }
    
    @Test func powerManagerInitialization() async throws {
        let pm = PowerManager.shared
        #expect(pm != nil)
    }
}
