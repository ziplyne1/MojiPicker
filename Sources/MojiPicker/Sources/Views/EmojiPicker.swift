import SwiftUI

@Observable
class EmojiPickerViewModel {
    let emojis: [Emoji]
    var categorySelection: EmojiCategory
    var searchText: String
    var error: Error?
    
    init() {
        self.categorySelection = .smileys
        self.searchText = ""
        do {
            self.emojis = try loadEmojis()
        } catch {
            self.emojis = []
            self.error = error
        }
    }
}

struct EmojiPicker: View {
    @State private var viewModel = EmojiPickerViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(viewModel.emojis, id:\.description) { emoji in
                    emojiCell(emoji)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
            Text(emoji.symbol)
                .font(.largeTitle)
        }
        .shadow(radius: 4)
        .frame(width: 65, height: 65)
    }
}

#Preview {
    EmojiPicker()
}
