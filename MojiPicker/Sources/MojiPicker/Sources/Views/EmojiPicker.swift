import SwiftUI

public struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var selectedEmoji: Emoji?
    
    private let emojis: [Emoji]
    @State private var categorySelection: EmojiCategory = .smileys
    @State private var searchText: String = ""
    @State private var error: Error? = nil
    
    @ScaledMetric(relativeTo: .largeTitle) private var cellSize: CGFloat = 52
        
    public init(selectedEmoji: Binding<Emoji?>) {
        self._selectedEmoji = selectedEmoji
        do {
            self.emojis = try loadEmojis()
        } catch {
            self.emojis = []
            self.error = error
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: cellSize), spacing: 0)],
                    spacing: 0
                ) {
                    ForEach(emojis, id:\.symbol) { emoji in
                        emojiCell(emoji)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Emojis")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .topBarLeading) { toolbarMenu }
#else
                ToolbarItem(placement: .automatic) { toolbarMenu }
#endif
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", systemImage: "checkmark") { dismiss() }
                }
            }
        }
    }
    
    // Child Views
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
        } label: {
            // fixme)) the emojis aren't centered, they're slightly left
            Text(emoji.symbol)
                .font(.custom("Emoji", size: 36, relativeTo: .largeTitle))
        }
        .frame(width: cellSize, height: cellSize, alignment: .center)
    }
    private var toolbarMenu: some View {
        Menu {
            Text("Selected: \(selectedEmoji?.symbol ?? "none")")
        } label: {
            if let symbol = selectedEmoji?.symbol {
                Text(symbol)
                    .font(.title)
            } else {
                Image(systemName: "face.dashed")
            }
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var selectedEmoji: Emoji? = nil
    @Previewable @State var showSheet = true
    
    VStack {
        Text("Selected emoji: \(selectedEmoji?.symbol ?? "none")")
        Button("Present Sheet") { showSheet = true }
            .sheet(isPresented: $showSheet) {
                EmojiPicker(selectedEmoji: $selectedEmoji)
            }
    }
}

#Preview {
    @Previewable @State var selectedEmoji: Emoji? = nil
    NavigationStack {
        EmojiPicker(selectedEmoji: $selectedEmoji)
    }
}
