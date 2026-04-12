import Foundation

enum EmojiLoaderError: Error {
    case fileNotFound
    case decodingFailed
}

func loadEmojis() throws -> [Emoji] {
    // load the file
    guard let url = Bundle.module.url(forResource: "emoji", withExtension: "json") else {
        throw EmojiLoaderError.fileNotFound
    }
    let data = try Data(contentsOf: url)
    
    // parse
    let emojis = try JSONDecoder().decode([Emoji].self, from: data)
    
    return emojis
}
