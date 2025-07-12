//
//  CarouselState.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Carousel State Management
class CarouselState: ObservableObject {
    @Published var activeIndex: Int = 0
    @Published var dragOffset: CGFloat = 0
    @Published var currentPage: Int = 0
    
    func updatePage() {
        currentPage = activeIndex
    }
    
    func navigateToPage(_ page: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            activeIndex = page
            currentPage = page
        }
        provideHapticFeedback()
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
} 