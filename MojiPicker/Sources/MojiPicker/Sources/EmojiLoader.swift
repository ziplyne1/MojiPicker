import Foundation

enum EmojiLoaderError: Error {
    case fileNotFound
    case decodingFailed
}

func loadEmojis() throws -> [EmojiCategory: [Emoji]] {
    // load the file
    guard let url = Bundle.module.url(forResource: "emoji", withExtension: "json") else {
        throw EmojiLoaderError.fileNotFound
    }
    let data = try Data(contentsOf: url)
    
    // parse
    var emojisByCategory: [EmojiCategory: [Emoji]] = [:]
    
    let emojis = try JSONDecoder().decode([Emoji].self, from: data)
    for emoji in emojis {
        emojisByCategory[emoji.category, default: []].append(emoji)
    }
    
    return emojisByCategory
}
