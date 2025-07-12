//
//  CarouselLayout.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 12/07/25.
//

import Foundation
import SwiftUI

// MARK: - Carousel Layout
struct CarouselLayout {
    let screenWidth: CGFloat
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let imageWidth: CGFloat
    let totalCardWidth: CGFloat
    
    init(geometry: GeometryProxy) {
        self.screenWidth = geometry.size.width
        self.cardWidth = geometry.size.width - (CarouselConfiguration.cardPadding * 2)
        self.cardHeight = cardWidth * CarouselConfiguration.aspectRatio
        self.imageWidth = cardWidth * 0.9
        self.totalCardWidth = imageWidth
    }
}
