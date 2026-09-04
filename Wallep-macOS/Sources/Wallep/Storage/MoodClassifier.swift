import Foundation

public enum WallpaperMood: String, CaseIterable, Identifiable {
    case calm = "Calm & Relaxing"
    case focus = "Deep Focus"
    case energetic = "Energetic & Fast"
    case cybernetic = "Cybernetic & Dark"
    case ethereal = "Ethereal & Dreamy"
    
    public var id: String { rawValue }
}

public struct MoodClassifier {
    public static func classify(item: WallpaperItem) -> WallpaperMood {
        switch item.category {
        case .nature: return .calm
        case .minimalist: return .focus
        case .cars, .cyberpunk: return .energetic
        case .space: return .ethereal
        case .anime, .abstract, .all: return .calm
        }
    }
}
