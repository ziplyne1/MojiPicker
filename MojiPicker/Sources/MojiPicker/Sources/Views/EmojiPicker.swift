import SwiftUI

public struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedEmoji: Emoji?
    
    private let emojis: [Emoji]
    @State private var categorySelection: EmojiCategory = .smileys
    @State private var searchText: String = ""
    @State private var error: Error? = nil
        
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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 55))]) {
                ForEach(emojis, id:\.description) { emoji in
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
    
    // Child Views
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
        } label: {
            Text(emoji.symbol)
                .padding(5)
                .font(.system(size: 48))
                .overlay(Circle().stroke(((emoji == selectedEmoji) ? Color.accentColor : Color.clear), lineWidth: 2))
        }
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
                NavigationStack {
                    EmojiPicker(selectedEmoji: $selectedEmoji)
                }
            }
    }
}
