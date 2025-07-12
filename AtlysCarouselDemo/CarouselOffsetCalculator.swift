//
//  CarouselOffsetCalculator.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Carousel Offset Calculator
struct CarouselOffsetCalculator {
    
    /// Calculates the horizontal offset for the carousel items container
    /// - Parameters:
    ///   - activeIndex: The currently active item index
    ///   - dragOffset: The current drag translation offset
    ///   - layout: The carousel layout information
    /// - Returns: The calculated offset to position the carousel items
    static func calculateOffset(
        activeIndex: Int,
        dragOffset: CGFloat,
        layout: CarouselLayout
    ) -> CGFloat {
        let centerOffset = CGFloat(activeIndex) * -layout.totalCardWidth
        let screenCenter = layout.screenWidth / 2
        let imageCenter = layout.totalCardWidth / 2
        let adjustment = screenCenter - imageCenter
        
        return centerOffset + adjustment + dragOffset
    }
} 