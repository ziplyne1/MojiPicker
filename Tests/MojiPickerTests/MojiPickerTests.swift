import Testing
@testable import MojiPicker

@Test func emojiLoads() throws {
    let emojis = try loadEmojis()
    
    // ensure all the categories loaded and have emojis
    for category in EmojiCategory.allCases {
        #expect(emojis[category] != nil)
    }
    
    // check a specific emoji
    let smiley = try #require(emojis[.smileys]?.first(where: { $0.symbol == "😀" }))
    #expect(smiley.description == "grinning face")
    #expect(smiley.aliases.contains("grinning"))
}
