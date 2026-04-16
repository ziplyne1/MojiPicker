enum EmojiCategory: String, Decodable, CaseIterable {
    case smileys = "Smileys & Emotion"
    case people = "People & Body"
    case nature = "Animals & Nature"
    case food = "Food & Drink"
    case travel = "Travel & Places"
    case activities = "Activities"
    case objects = "Objects"
    case symbols = "Symbols"
    case flags = "Flags"
    
    var sfSymbol: String {
        switch self {
        case .smileys: "face.smiling"
        case .people: "person"
        case .nature: "leaf"
        case .food: "cup.and.saucer"
        case .travel: "car"
        case .activities: "basketball"
        case .objects: "lightbulb"
        case .symbols: "star"
        case .flags: "flag"
        }
    }
}
