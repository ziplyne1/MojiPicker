import SwiftUI
import MojiPicker

struct ContentView: View {
    @State private var showSheetPicker: Bool = false
    @State private var sheetSelectedSymbol: String? = nil
    @State private var dismissSheetOnSelect: Bool = true
    
    @State private var linkSelectedSymbol: String? = nil
    @State private var dismissLinkOnSelect: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                listSection(style: .sheet)
                listSection(style: .link)
            }
            .navigationTitle("MojiPicker demo")
        }
    }
    
    
    private enum ListSectionStyle {
        case link, sheet
        var displayName: String {
            switch self {
            case .link: "Link"
            case .sheet: "Sheet"
            }
        }
    }
    
    @ViewBuilder
    private func listSection(style: ListSectionStyle) -> some View {
        Section(style.displayName) {
            if style == .link {
                NavigationLink {
                    EmojiPicker(selectedSymbol: $linkSelectedSymbol, dismissOnSelection: dismissLinkOnSelect)
                } label: {
                    Text("Selected: \(linkSelectedSymbol ?? "none")")
                }
            } else if style == .sheet {
                HStack {
                    Text("Selected: \(sheetSelectedSymbol ?? "none")")
                    Spacer()
                    Button("Present picker") { showSheetPicker = true}
                        .emojiPicker(isPresented: $showSheetPicker, selectedSymbol: $sheetSelectedSymbol, dismissOnSelection: dismissSheetOnSelect)
                }
            }
            
            let isOn = switch style {
            case .link: $dismissLinkOnSelect
            case .sheet: $dismissSheetOnSelect
            }
            Toggle("Dismiss on selection", isOn: isOn)
        }
    }
}

#Preview {
    ContentView()
}
