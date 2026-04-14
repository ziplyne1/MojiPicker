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
    
    var modifier: String {
        switch self {
        case .neutral: return ""
        case .light: return "\u{1F3FB}"
        case .mediumLight: return "\u{1F3FC}"
        case .medium: return "\u{1F3FD}"
        case .mediumDark: return "\u{1F3FE}"
        case .dark: return "\u{1F3FF}"
        }
    }
    
    // fixme)) some emojis (like "👯") don't have skin tones properly applied
    func apply(to emoji: Emoji) -> String {
        guard emoji.usesSkinTones == true else { return emoji.symbol }
        
        let scalars = emoji.decomposed()
        var stringScalars = scalars.map { String($0) }
        guard let firstScalar = scalars.first else { return emoji.symbol }
        
        if Emoji.nonPersonModifierBases.contains(firstScalar) || scalars.count(where: { $0.properties.isEmojiModifierBase }) == 1 {
            // if it's only one modifiable emoji, modify it no matter what
            // or if the first scalar is a non-human modifier base
            stringScalars[0] += modifier
        } else {
            // if it's more than one modifiable emoji, only modify the people
            for scalar in scalars {
                if scalar.properties.isEmojiModifierBase && !Emoji.nonPersonModifierBases.contains(scalar) {
                    if let index = stringScalars.firstIndex(of: String(scalar)) {
                        stringScalars[index] += modifier
                    }
                }
            }
        }
        return stringScalars.joined()
    }
    
    static func find(from symbol: String) -> EmojiSkinTone? {
        for tone in EmojiSkinTone.allCases {
            if symbol.unicodeScalars.contains(where: { String($0) == tone.modifier }) {
                return tone
            }
        }
        return nil
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
