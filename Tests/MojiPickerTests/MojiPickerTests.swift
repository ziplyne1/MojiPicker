import Testing
@testable import MojiPicker

@Test func emojiLoads() throws {
    let emojis = try loadEmojis()
    
    // check a specific emoji
    let smiley = try #require(emojis.first(where: { $0.symbol == "😀" }), "ensure it loaded the grinning face emoji")
    #expect(smiley.description == "grinning face", "check that the description property was set properly")
    #expect(smiley.aliases.contains("grinning"), "check that the aliases property was set properly")
}
