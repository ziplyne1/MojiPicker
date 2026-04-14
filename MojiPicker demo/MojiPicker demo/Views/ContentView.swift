import SwiftUI
import MojiPicker

struct ContentView: View {
    @State private var selectedSymbol: String? = nil
    @State private var showPicker: Bool = false
    
    var body: some View {
        VStack {
            Text("Selected emoji: \(selectedSymbol ?? "none")")
            Button("Present picker") { showPicker = true}
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            EmojiPicker(selectedSymbol: $selectedSymbol)
        }
    }
}

#Preview {
    ContentView()
}
