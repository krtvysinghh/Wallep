import Foundation

public struct LocalizedString {
    public static func get(_ key: String, lang: String = "en") -> String {
        let dict: [String: [String: String]] = [
            "app_name": ["en": "Wallep", "ja": "Wallep", "de": "Wallep", "fr": "Wallep"],
            "browse_gallery": ["en": "Browse 4K Wallpapers", "ja": "4K壁紙を見る", "de": "4K Hintergründe durchsuchen", "fr": "Parcourir les fonds 4K"],
            "auto_change": ["en": "Auto-Change", "ja": "自動変更", "de": "Automatisch wechseln", "fr": "Changement automatique"],
            "settings": ["en": "Preferences", "ja": "設定", "de": "Einstellungen", "fr": "Préférences"]
        ]
        return dict[key]?[lang] ?? dict[key]?["en"] ?? key
    }
}
