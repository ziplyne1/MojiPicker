public struct Emoji: Decodable, Equatable {
    public let symbol: String
    let description: String
    let category: EmojiCategory
    let aliases: [String]
    let tags: [String]
    let skinTones: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "emoji"
        case skinTones = "skin_tones"
        case description, category, aliases, tags
    }
}
