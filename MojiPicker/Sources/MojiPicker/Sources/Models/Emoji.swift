public struct Emoji: Decodable, Equatable {
    let symbol: String
    let description: String
    let category: EmojiCategory
    let aliases: [String]
    let tags: [String]
    let usesSkinTones: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "emoji"
        case usesSkinTones = "skin_tones"
        case description, category, aliases, tags
    }
}

extension Emoji {
    static let nonPersonModifierBases: Set<Unicode.Scalar> = ["🤝"]
}

extension Emoji {
    func decomposed() -> [Unicode.Scalar] {
        symbol.unicodeScalars.map { $0 }
    }
    
    public static func find(_ symbol: String) -> Emoji? {
        var emojis: [Emoji] = []
        do {
            emojis = try loadEmojis()
        } catch {
            // todo)) handle errors
        }
        
        let baseSymbol: String = String(symbol.unicodeScalars.filter {
            !($0.value >= 0x1F3FB && $0.value <= 0x1F3FF)
        })
        let foundEmoji: Emoji? = emojis.first(where: { $0.symbol == baseSymbol })
        
        return foundEmoji
    }
}
