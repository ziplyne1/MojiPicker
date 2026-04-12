import SwiftUI
import MojiPicker

struct ContentView: View {
    @State private var selectedEmoji: Emoji? = nil
    @State private var showPicker: Bool = false
    
    var body: some View {
        VStack {
            Text("Selected emoji: \(selectedEmoji?.symbol ?? "none")")
            Button("Present picker") { showPicker = true}
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            EmojiPicker(selectedEmoji: $selectedEmoji)
        }
    }
}

#Preview {
    ContentView()
}
