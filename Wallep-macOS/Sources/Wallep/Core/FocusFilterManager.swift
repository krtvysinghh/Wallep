import Foundation
import Combine

public enum FocusModeType: String, CaseIterable, Identifiable {
    case none = "Off"
    case work = "Work & Coding"
    case personal = "Personal & Chill"
    case gaming = "Gaming & Esports"
    case sleep = "Night Sleep"
    
    public var id: String { rawValue }
}

public final class FocusFilterManager: ObservableObject {
    public static let shared = FocusFilterManager()
    
    @Published public var activeFocusMode: FocusModeType = .none
    @Published public var isFocusFilterSyncEnabled: Bool = true
    
    private init() {}
    
    public func setFocusMode(_ mode: FocusModeType) {
        self.activeFocusMode = mode
        guard isFocusFilterSyncEnabled else { return }
        
        // Match appropriate category playlist based on focus mode
        switch mode {
        case .work:
            LibraryManager.shared.selectedCategory = .minimalist
        case .personal:
            LibraryManager.shared.selectedCategory = .anime
        case .gaming:
            LibraryManager.shared.selectedCategory = .cyberpunk
        case .sleep:
            LibraryManager.shared.selectedCategory = .space
        case .none:
            LibraryManager.shared.selectedCategory = .all
        }
    }
}
