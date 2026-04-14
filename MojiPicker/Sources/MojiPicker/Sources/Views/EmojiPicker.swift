import SwiftUI

public struct EmojiPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var selectedSymbol: String?
    @State private var selectedEmoji: Emoji?
    private var selectedEmojiSymbolWithSkinTone: String? {
        if let emoji = selectedEmoji {
            return selectedSkinTone.apply(to: emoji)
        }
        return nil
    }
    
    private let emojis: [Emoji]
    @State private var categorySelection: EmojiCategory = .smileys
    @State private var searchText: String = ""
    @State private var error: Error? = nil
    
    @State private var selectedSkinTone: EmojiSkinTone = .neutral
    @State private var dismissOnSelection = true
    
    @ScaledMetric(relativeTo: .largeTitle) private var cellSize: CGFloat = 52
    
    public init(
        selectedSymbol: Binding<String?>,
        dismissOnSelection: Bool = true
    ) {
        self._selectedSymbol = selectedSymbol
        if let symbol = selectedSymbol.wrappedValue {
            self.selectedEmoji = Emoji.find(symbol)
        }
        
        self.dismissOnSelection = dismissOnSelection
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
        .onChange(of: selectedEmoji) {
            updateSelectedSymbol()
        }
        .onChange(of: selectedSkinTone) {
            updateSelectedSymbol()
        }
    }
    
    private func updateSelectedSymbol() {
        if let emoji = selectedEmoji {
            selectedSymbol = selectedSkinTone.apply(to: emoji)
        }
    }
    
    // ----- Child Views -----
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
            if dismissOnSelection {
                dismiss()
            }
        } label: {
            // fixme)) the emojis aren't centered, they're slightly left
            let displayText: String = {
                selectedEmojiSymbolWithSkinTone ?? "none"
            }()
            
            Text(displayText)
                .font(.custom("Emoji", size: 36, relativeTo: .largeTitle))
        }
        .frame(width: cellSize, height: cellSize, alignment: .center)
        .buttonStyle(.plain)
    }
    
    private var toolbarMenu: some View {
        Menu {
            Text("Selected: \(selectedEmojiSymbolWithSkinTone ?? "none")")
            Menu {
                ForEach(EmojiSkinTone.allCases, id:\.self) { tone in
                    Button(tone.previewSymbol + " " + tone.displayName) {
                        selectedSkinTone = tone
                    }
                }
            } label: {
                Text("Skin tone: \(selectedSkinTone.previewSymbol)")
            }
        } label: {
            if let symbol = selectedEmojiSymbolWithSkinTone {
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
    @Previewable @State var selectedSymbol: String? = nil
    @Previewable @State var showSheet = true
    
    VStack {
        Text("Selected emoji: \(selectedSymbol ?? "none")")
        Button("Present Sheet") { showSheet = true }
            .sheet(isPresented: $showSheet) {
                EmojiPicker(selectedSymbol: $selectedSymbol, dismissOnSelection: false)
            }
    }
}

#Preview {
    @Previewable @State var selectedSymbol: String? = nil
    EmojiPicker(selectedSymbol: $selectedSymbol, dismissOnSelection: false)
}
