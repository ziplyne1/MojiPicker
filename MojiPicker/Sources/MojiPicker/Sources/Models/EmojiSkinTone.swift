public enum EmojiSkinTone: CaseIterable {
    case neutral
    case light, mediumLight, medium, mediumDark, dark
    
    public var displayName: String {
        switch self {
        case .neutral: return "Neutral"
        case .light: return "Light"
        case .mediumLight: return "Medium Light"
        case .medium: return "Medium"
        case .mediumDark: return "Medium Dark"
        case .dark: return "Dark"
        }
    }
    
    public var previewSymbol: String {
        switch self {
        case .neutral: return "👍"
        case .light: return "👍🏻"
        case .mediumLight: return "👍🏼"
        case .medium: return "👍🏽"
        case .mediumDark: return "👍🏾"
        case .dark: return "👍🏿"
        }
    }
    
    public var modifier: String {
        switch self {
        case .neutral: return ""
        case .light: return "\u{1F3FB}"
        case .mediumLight: return "\u{1F3FC}"
        case .medium: return "\u{1F3FD}"
        case .mediumDark: return "\u{1F3FE}"
        case .dark: return "\u{1F3FF}"
        }
    }
}
