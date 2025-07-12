# Atlys Carousel Demo

A custom SwiftUI carousel component that provides smooth, interactive scrolling with visual effects and pagination.

## 🎯 Features

- **Smooth Panning**: Real-time visual feedback during drag operations
- **Pagination**: Automatic centering to nearest tile with snap-to-center
- **Visual Effects**: Center image zoom with smooth transitions
- **Dynamic Layout**: Responsive height adjustment (250pt default, 1:1 aspect ratio)
- **Full Width**: Utilizes complete screen width with proper spacing
- **No Dependencies**: Built entirely with SwiftUI (no third-party libraries)

## 🏗️ Architecture

The carousel follows a modular architecture with clear separation of concerns:

```
CarouselView (Main Container)
├── CarouselContentView (Layout Manager)
├── PaginationView (Navigation Dots)
└── Supporting Components
    ├── CarouselState (State Management)
    ├── CarouselEffects (Visual Effects)
    ├── CarouselGestureHandler (Interaction Logic)
    └── CarouselConfiguration (Constants)
```

## 🚀 Quick Start

1. **Add Images**: Place your images in `Assets.xcassets`
2. **Configure Items**: Modify `CarouselViewModel.swift` to add your carousel items
3. **Customize**: Adjust visual effects in `CarouselConfiguration.swift`
4. **Integrate**: Use `CarouselView` in your SwiftUI app

### Example Usage

```swift
struct ContentView: View {
    var body: some View {
        CarouselView()
            .frame(maxWidth: .infinity)
    }
}
```

## 📁 Project Structure

- `CarouselView.swift` - Main carousel container
- `CarouselItemView.swift` - Individual carousel item
- `CarouselState.swift` - State management
- `CarouselEffects.swift` - Visual effects calculations
- `CarouselGestureHandler.swift` - Gesture handling
- `CarouselConfiguration.swift` - Configuration constants
- `PaginationView.swift` - Navigation dots
- `CarouselLayout.swift` - Layout calculations
- `CarouselOffsetCalculator.swift` - Positioning logic
- `RoundedCorner.swift` - Custom shape for rounded corners

## 🔧 Extensibility

Adding new images takes less than 5 minutes:

```swift
// In CarouselViewModel.swift
let items: [CarouselItem] = [
    CarouselItem(imageName: "yourImage", title: "Your Title", subtitle: "Your Subtitle")
]
```

## 📚 Documentation

For detailed implementation documentation, architecture decisions, and technical specifications, see:

**[📖 Full Documentation](https://docs.google.com/document/d/1wu-4hhyGa8bjocJNsFqI9YXYSxQbOEwmi5VdiMHQnWs/edit?usp=sharing)**

## ✅ Requirements Met

- ✅ Smooth panning behavior
- ✅ Pagination with snap-to-center
- ✅ Visual effects (zoom, opacity)
- ✅ Dynamic height adjustment
- ✅ Full width utilization
- ✅ No third-party dependencies
- ✅ High extensibility
- ✅ Clean, maintainable code

## 🎨 Design Principles

- **Approach Over Functionality**: Focus on clean architecture
- **Simplicity and Structure**: Modular, readable code
- **Quality Over Speed**: Maintainable and extensible design

---

Built with ❤️ using SwiftUI

<img width="503" height="954" alt="Screenshot 2025-07-12 at 9 20 02 PM" src="https://github.com/user-attachments/assets/be739936-22e1-4241-be19-cbd311ce57cf" />



https://github.com/user-attachments/assets/66387496-8384-45ce-a486-600c85ba842c


