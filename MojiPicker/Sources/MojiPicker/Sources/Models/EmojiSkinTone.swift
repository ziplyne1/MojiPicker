public enum EmojiSkinTone: CaseIterable {
    case neutral
    case light, mediumLight, medium, mediumDark, dark
    
    var displayName: String {
        switch self {
        case .neutral: return "Neutral"
        case .light: return "Light"
        case .mediumLight: return "Medium Light"
        case .medium: return "Medium"
        case .mediumDark: return "Medium Dark"
        case .dark: return "Dark"
        }
    }
    
    var previewSymbol: String {
        switch self {
        case .neutral: return "👍"
        case .light: return "👍🏻"
        case .mediumLight: return "👍🏼"
        case .medium: return "👍🏽"
        case .mediumDark: return "👍🏾"
        case .dark: return "👍🏿"
        }
    }
    
    private var modifier: String {
        switch self {
        case .neutral: return ""
        case .light: return "\u{1F3FB}"
        case .mediumLight: return "\u{1F3FC}"
        case .medium: return "\u{1F3FD}"
        case .mediumDark: return "\u{1F3FE}"
        case .dark: return "\u{1F3FF}"
        }
    }
    
    func apply(to emoji: Emoji) -> String {
        if emoji.usesSkinTones == true {
            var scalars = emoji.decomposed()
            scalars[0] += modifier
            return scalars.joined()
        } else {
            return emoji.symbol
        }
    }
    
//    init(unicodeScalar scalar: UnicodeScalar) {
//        switch scalar {
//        case "\u{1F3FB}": self = EmojiSkinTone.light
//        case "\u{1F3FC}": self = EmojiSkinTone.mediumLight
//        case "\u{1F3FD}": self = EmojiSkinTone.medium
//        case "\u{1F3FE}": self = EmojiSkinTone.mediumDark
//        case "\u{1F3FF}": self = EmojiSkinTone.dark
//        default: self = EmojiSkinTone.neutral
//        }
//    }
}
