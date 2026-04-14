import Testing
@testable import MojiPicker

@Test("Load emojis")
func loadEmojisReturnsEmojis() throws {
    let emojis = try loadEmojis()
    #expect(emojis != [])
    
    // check a specific emoji
    let smiley = try #require(emojis.first(where: { $0.symbol == "😀" }), "ensure it loaded the grinning face emoji")
    #expect(smiley.description == "grinning face", "check that the description property was set properly")
    #expect(smiley.aliases.contains("grinning"), "check that the aliases property was set properly")
}

@Test("Find emojis from symbols")
func findEmojisWorks() throws {
    #expect(Emoji.find("🥰")?.symbol == "🥰")
    #expect(Emoji.find("🙎🏽‍♂️")?.symbol == "🙎‍♂️") // Emoji can't hold skin tones
    #expect(Emoji.find("👩🏽‍❤️‍💋‍👨🏽")?.symbol == "👩‍❤️‍💋‍👨")
    
    #expect(Emoji.find("notanemoji") == nil)
    
    #expect(Emoji.find("\u{1F3FC}") == nil)
    #expect(Emoji.find("\u{200D}") == nil)
}

@Test("Find skin tone from symbol")
func findSkinToneFromSymbolWorks() throws {
    #expect(EmojiSkinTone.find(from: "👍") == nil)
    #expect(EmojiSkinTone.find(from: "👍🏻") == .light)
    #expect(EmojiSkinTone.find(from: "👍🏼") == .mediumLight)
    #expect(EmojiSkinTone.find(from: "👍🏽") == .medium)
    #expect(EmojiSkinTone.find(from: "👍🏾") == .mediumDark)
    #expect(EmojiSkinTone.find(from: "👍🏿") == .dark)
    
    #expect(EmojiSkinTone.find(from: "🧔🏿‍♂️") == .dark)
    #expect(EmojiSkinTone.find(from: "🧑🏾‍🤝‍🧑🏾") == .mediumDark)
}

@Test("Apply skin tones")
func emojiSkinToneApplyFunctionWorks() throws {
    let thumbsUp = try #require(Emoji.find("👍"))
    #expect(EmojiSkinTone.neutral.apply(to: thumbsUp)     == "👍")
    #expect(EmojiSkinTone.light.apply(to: thumbsUp)       == "👍🏻")
    #expect(EmojiSkinTone.mediumLight.apply(to: thumbsUp) == "👍🏼")
    #expect(EmojiSkinTone.medium.apply(to: thumbsUp)      == "👍🏽")
    #expect(EmojiSkinTone.mediumDark.apply(to: thumbsUp)  == "👍🏾")
    #expect(EmojiSkinTone.dark.apply(to: thumbsUp)        == "👍🏿")
    
    let handshake = try #require(Emoji.find("🤝"))
    #expect(EmojiSkinTone.light.apply(to: handshake) == "🤝🏻")
    let beardedMan = try #require(Emoji.find("🧔‍♂️"))
    #expect(EmojiSkinTone.dark.apply(to: beardedMan) == "🧔🏿‍♂️")
    let holdingHands = try #require(Emoji.find("🧑‍🤝‍🧑"))
    #expect(EmojiSkinTone.mediumDark.apply(to: holdingHands) == "🧑🏾‍🤝‍🧑🏾")
    let kissing = try #require(Emoji.find("👩‍❤️‍💋‍👨"))
    #expect(EmojiSkinTone.mediumLight.apply(to: kissing) == "👩🏼‍❤️‍💋‍👨🏼")
    
//    let bunnyEars = try #require(Emoji.find("👯‍♀️"))
//    #expect(EmojiSkinTone.dark.apply(to: bunnyEars) == "👯🏿‍♀️")
    
    let fish = try #require(Emoji.find("🐟"))
    #expect(EmojiSkinTone.light.apply(to: fish) == "🐟")
}

@Test("Round trip emoji manipulation")
func findEmojiApplySkinToneThenFindReturnsOriginal() throws {
    let originalEmoji = try #require(Emoji.find("🙋‍♀️"))
    let mediumDarkEmojiSymbol = EmojiSkinTone.mediumDark.apply(to: originalEmoji)
    let finalEmoji = try #require(Emoji.find(mediumDarkEmojiSymbol))
    #expect(finalEmoji == originalEmoji)
}

@Test("Decompose bearded woman")
func decomposingMediumDarkBeardedWomanReturnsProperUnicodeScalars() throws {
    let beardedWoman = try #require(Emoji.find("🧔🏽‍♀️"))
    #expect(
        beardedWoman.decomposed()
        ==
        ["🧔", "\u{200D}", "♀", "\u{FE0F}"] // Emojis don't support skin tones
        )
}
