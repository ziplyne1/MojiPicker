# MojiPicker
A drop-in SwiftUI emoji picker.  
Made with 💜 by [ziplyne](https://ziplyne.dev).

![A GIF showing off the demonstration app](https://github.com/user-attachments/assets/b087de84-44cb-45eb-aeb0-7987a03172bc)

## Installation
Install MojiPicker using the [Swift Package Manager](https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/).

In Xcode, go to File → Add Package Dependencies…  
Then, enter the following URL and select “Add Package.”
```
https://github.com/ziplyne1/MojiPicker
```

## Usage
After importing MojiPicker, you can show an emoji picker in two ways:
1. Initialize an `EmojiPicker`
2. Apply the `.emojiPicker` view modifier

### EmojiPicker
```swift
EmojiPicker(
  selectedSymbol: Binding<String?>,
  // dismissOnSelection: Bool = true
)
```

### .emojiPicker
```swift
MyView()
  .emojiPicker(
    isPresented: Binding<Bool>,
    selectedSymbol: Binding<String?>,
    // dismissOnSelection: Bool = true
  )
```

### Example
```swift
@State private var showPicker = false
@State private var selectedSymbol: String? = nil

var body: some View {
  Button("Pick Emoji") {
    showPicker = true
  }
    .emojiPicker(
      isPresented: $showPicker,
      selectedSymbol: $selectedSymbol
    )
}
```

## Contributing
All contributions are welcome. Please open a pull request and give a clear description of your changes.

### Building
In order to keep the `.xcodeproj` of the demo app clean, please run the `setup.sh` script before building the app, as it configures local signing settings required for the demo app to build. It will create a file called `DeveloperSettings.xcconfig` which will not be committed to GitHub.

You may need to run `chmod +x setup.sh` to make the script executable.
