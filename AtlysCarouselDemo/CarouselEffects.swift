//
//  CarouselEffects.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Carousel Visual Effects
struct CarouselEffects {
    
    /// Calculates the scale effect for a carousel item based on its distance from the active index
    /// - Parameters:
    ///   - index: The index of the current item
    ///   - activeIndex: The currently active item index
    /// - Returns: The scale factor to apply to the item
    static func getScale(for index: Int, activeIndex: Int) -> CGFloat {
        let distance = abs(index - activeIndex)
        
        switch distance {
        case 0:
            return CarouselConfiguration.centerScale
        case 1:
            return CarouselConfiguration.sideScale
        default:
            return CarouselConfiguration.sideScale * 0.9
        }
    }
    
    /// Calculates the opacity for a carousel item based on its distance from the active index
    /// - Parameters:
    ///   - index: The index of the current item
    ///   - activeIndex: The currently active item index
    /// - Returns: The opacity value to apply to the item
    static func getOpacity(for index: Int, activeIndex: Int) -> CGFloat {
        let distance = abs(index - activeIndex)
        
        switch distance {
        case 0:
            return 1.0
        case 1:
            return CarouselConfiguration.sideOpacity
        default:
            return CarouselConfiguration.sideOpacity * 0.5
        }
    }
} 