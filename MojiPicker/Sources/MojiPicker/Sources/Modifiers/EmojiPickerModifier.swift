import SwiftUI

extension View {
    public func emojiPicker(isPresented: Binding<Bool>, selectedSymbol: Binding<String?>, dismissOnSelection: Bool = true) -> some View {
        self.sheet(isPresented: isPresented) {
            EmojiPicker(selectedSymbol: selectedSymbol, dismissOnSelection: dismissOnSelection)
        }
    }
}
