import SwiftUI

struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedEmoji: Emoji?
    
    private let emojis: [Emoji]
    @State private var categorySelection: EmojiCategory = .smileys
    @State private var searchText: String = ""
    @State private var error: Error? = nil
    
    @ScaledMetric(relativeTo: .largeTitle) private var cellSize: CGFloat = 55
    
    init(selectedEmoji: Binding<Emoji?>) {
        self._selectedEmoji = selectedEmoji
        do {
            self.emojis = try loadEmojis()
        } catch {
            self.emojis = []
            self.error = error
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: cellSize))]) {
                ForEach(emojis, id:\.description) { emoji in
                    emojiCell(emoji)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Emojis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
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
            ToolbarItem(placement: .topBarLeading) {
                Text(String(Int(cellSize)))
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Confirm", systemImage: "checkmark") { dismiss() }
            }
        }
    }
    
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
        } label: {
            Text(emoji.symbol)
                .frame(width: cellSize, height: cellSize)
                .padding(5)
                .font(.system(size: 48))
                .overlay(Circle().stroke(((emoji == selectedEmoji) ? Color.accentColor : Color.clear), lineWidth: 2))
        }
    }
}

#Preview {
    @Previewable @State var selectedEmoji: Emoji? = nil
    @Previewable @State var showSheet = true
    
    VStack {
        Text("Selected emoji: \(selectedEmoji?.symbol ?? "none")")
        Button("Present Sheet") { showSheet = true }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    EmojiPicker(selectedEmoji: $selectedEmoji)
                }
            }
    }
}
