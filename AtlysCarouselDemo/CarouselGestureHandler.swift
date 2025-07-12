//
//  CarouselGestureHandler.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Carousel Gesture Handler
struct CarouselGestureHandler {
    
    /// Creates a drag gesture for the carousel with proper handling of drag events
    /// - Parameters:
    ///   - carouselState: The carousel state object to update
    ///   - itemCount: The total number of items in the carousel
    ///   - layout: The carousel layout information
    /// - Returns: A configured drag gesture
    static func createDragGesture(
        carouselState: CarouselState,
        itemCount: Int,
        layout: CarouselLayout
    ) -> some Gesture {
        DragGesture()
            .onChanged { value in
                carouselState.dragOffset = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(
                    value: value,
                    carouselState: carouselState,
                    itemCount: itemCount,
                    layout: layout
                )
            }
    }
    
    /// Handles the end of a drag gesture and determines the next active index
    /// - Parameters:
    ///   - value: The drag gesture value containing translation and prediction data
    ///   - carouselState: The carousel state object to update
    ///   - itemCount: The total number of items in the carousel
    ///   - layout: The carousel layout information
    private static func handleDragEnd(
        value: DragGesture.Value,
        carouselState: CarouselState,
        itemCount: Int,
        layout: CarouselLayout
    ) {
        let dragThreshold = layout.cardWidth / 3
        let predictedEnd = value.predictedEndTranslation.width
        
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
            if value.translation.width < -dragThreshold || predictedEnd < -layout.cardWidth {
                carouselState.activeIndex = min(carouselState.activeIndex + 1, itemCount - 1)
            } else if value.translation.width > dragThreshold || predictedEnd > layout.cardWidth {
                carouselState.activeIndex = max(carouselState.activeIndex - 1, 0)
            }
            carouselState.dragOffset = 0
        }
        
        carouselState.updatePage()
        provideHapticFeedback()
    }
    
    /// Provides haptic feedback when the carousel changes pages
    private static func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
} 