import Testing
@testable import MojiPicker

@Test func emojiLoads() throws {
    // todo)) should i put "comment" parameters in the expectations and requirements?
    let emojis = try loadEmojis()
    
    // check a specific emoji
    let smiley = #require(emojis.first(where: { $0.symbol == "😀" }))
    #expect(smiley.description == "grinning face")
    #expect(smiley.aliases.contains("grinning"))
}
