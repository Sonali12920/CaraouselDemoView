//
//  ContentView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 11/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CarouselView()
                .frame(height: 250)
        }
        .padding(.horizontal, 8)
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
