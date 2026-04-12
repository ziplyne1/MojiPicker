public struct Emoji: Decodable, Equatable {
    let symbol: String
    let description: String
    let category: EmojiCategory
    let aliases: [String]
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case symbol = "emoji"
        case description, category, aliases, tags
    }
}
