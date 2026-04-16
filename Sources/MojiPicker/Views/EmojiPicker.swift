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
    
    @State private var selectedSkinTone: EmojiSkinTone = .neutral
    @State private var dismissOnSelection = true
    
    private let emojis: [Emoji]
    
    @State private var filteredEmojis: [Emoji] = []
    @State private var selectedCategory: EmojiCategory? = nil
    @State private var searchText: String = ""
    @State private var selectSearchField: Bool = false
    
    @State private var error: Error? = nil
    
    @ScaledMetric(relativeTo: .largeTitle) private var cellSize: CGFloat = 52
    
    public init(
        selectedSymbol: Binding<String?>,
        dismissOnSelection: Bool = true
    ) {
        self._selectedSymbol = selectedSymbol
        if let symbol = selectedSymbol.wrappedValue {
            self.selectedEmoji = Emoji.find(symbol)
            if let tone = EmojiSkinTone.find(from: symbol) {
                self.selectedSkinTone = tone
            }
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
                    ForEach(filteredEmojis, id:\.symbol) { emoji in
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
            .searchable(text: $searchText, isPresented: $selectSearchField)
            .safeAreaBar(edge: .bottom) { categoryPicker }
        }
        
        .onChange(of: selectedSymbol) {
            if dismissOnSelection {
                dismiss()
            }
        }
        
        .onChange(of: selectedEmoji)    { updateSelectedSymbol() }
        .onChange(of: selectedSkinTone) { updateSelectedSymbol() }
        
        .onChange(of: selectedCategory) { filterEmojis() }
        .onChange(of: searchText)       { filterEmojis() }
        
        .onChange(of: selectSearchField) {
            if selectSearchField == true {
                selectedCategory = nil
            }
        }
        
        .onAppear { filterEmojis() }
    }
    
    
    // ----- Child Views -----
    @ViewBuilder func emojiCell(_ emoji: Emoji) -> some View {
        Button {
            selectedEmoji = emoji
        } label: {
            // fixme)) the emojis aren't centered, they're slightly left
            let displayText: String = {
                selectedSkinTone.apply(to: emoji)
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
#if os(macOS)
        .buttonStyle(.accessoryBar)
#else
        .buttonStyle(.plain)
#endif
    }
    
    private var categoryPicker: some View {
        HStack(spacing: 0) {
            ForEach(EmojiCategory.allCases, id: \.self) { category in
                Button {
                    if category == selectedCategory {
                        selectedCategory = nil
                    } else {
                        selectedCategory = category
                    }
                } label: {
                    let imageName: String = {
                        if category == selectedCategory {
                            return category.sfSymbol + ".fill"
                        } else {
                            return category.sfSymbol
                        }
                    }()
                    
                    Image(systemName: imageName)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 32, height: 32)
                        .padding(.horizontal, 2)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 25)
    }
    
    
    // ----- Functions -----
    private func filterEmojis() {
        filteredEmojis = emojis.filter { emoji in
            let satisfiesCategory: Bool = {
                if selectedCategory == nil {
                    return true
                } else if selectedCategory == emoji.category {
                    return true
                } else {
                    return false
                }
            }()
            
            let satisfiesSearchText: Bool = {
                let query = searchText.lowercased()
                
                // match search text
                if query == "" { return true }
                let matchableText = (
                    emoji.symbol +
                    emoji.description +
                    emoji.aliases.joined() +
                    emoji.tags.joined()
                ).lowercased()
                if matchableText.contains(query) { return true }
                
                return false
            }()
            
            return satisfiesCategory && satisfiesSearchText
        }
    }
    
    private func updateSelectedSymbol() {
        if let emoji = selectedEmoji {
            selectedSymbol = selectedSkinTone.apply(to: emoji)
        }
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
