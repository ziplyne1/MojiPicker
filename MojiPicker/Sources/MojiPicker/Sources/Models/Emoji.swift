public struct Emoji: Decodable, Equatable {
    public let symbol: String
    let description: String
    let category: EmojiCategory
    let aliases: [String]
    let tags: [String]
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "emoji"
        case description, category, aliases, tags
    }
}
