import SwiftUI

struct ContentView: View {
    var body: some View {
        // Main container with safe area handling
        VStack {
            // Optional: Add spacing at the top if needed
            // Spacer().frame(height: 20)
            
            // Your Atlys Carousel (standalone component)
            CarouselView()
                .frame(height: 250) // Default height (will adjust content)
            
            // Optional: Add spacing at the bottom if needed
            // Spacer()
        }
        .padding(.horizontal, 8) // Small side padding if needed
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("iPhone 15")
            .previewDevice("iPhone 15")
        
        ContentView()
            .previewDisplayName("iPhone SE")
            .previewDevice("iPhone SE (3rd generation)")
    }
}
