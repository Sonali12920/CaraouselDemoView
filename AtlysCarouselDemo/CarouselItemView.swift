//
//  CarouselItemView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 12/07/25.
//

import Foundation
import SwiftUI

// MARK: - Carousel Item View
struct CarouselItemView: View {
    let item: CarouselItem
    let index: Int
    let activeIndex: Int
    let layout: CarouselLayout
    
    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: layout.imageWidth, height: layout.cardHeight * CarouselConfiguration.imageHeightRatio)
            .clipped()
            .clipShape(getCornerRadius())
            .overlay(contentOverlay, alignment: .leading)
            .frame(width: layout.imageWidth, height: layout.cardHeight)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
    }
    
    private var contentOverlay: some View {
        VStack(alignment: .leading, spacing: CarouselConfiguration.overlaySpacing) {
            Spacer()
            Spacer()
            titleText
            subtitleText
        }
        .padding(.bottom, CarouselConfiguration.overlayBottomPadding)
    }
    
    private var titleText: some View {
        Text(item.title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(radius: 2)
            .lineLimit(1)
            .padding(.leading, CarouselConfiguration.titleLeadingPadding)
    }
    
    private var subtitleText: some View {
        Text(item.subtitle)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, CarouselConfiguration.subtitlePadding)
            .padding(.vertical, 4)
            .background(Color.purple)
            .cornerRadius(4)
            .padding(.leading, 0)
    }
    
    private var isActive: Bool {
        index == activeIndex
    }
    
    private func getCornerRadius() -> AnyShape {
        let distance = abs(index - activeIndex)
        
        switch distance {
        case 0:
            return AnyShape(RoundedRectangle(cornerRadius: CarouselConfiguration.cornerRadius))
        case 1:
            return getSideImageCornerRadius()
        default:
            return AnyShape(RoundedRectangle(cornerRadius: CarouselConfiguration.cornerRadius))
        }
    }
    
    private func getSideImageCornerRadius() -> AnyShape {
        // When spacing is 0, images are touching, so corners where they meet should be flat
        if CarouselConfiguration.spacing == 0 {
            if index < activeIndex {
                // Left image - only left corners rounded (right corners are flat where it touches center)
                return AnyShape(RoundedCorner(radius: CarouselConfiguration.cornerRadius, corners: [.topLeft, .bottomLeft]))
            } else {
                // Right image - only right corners rounded (left corners are flat where it touches center)
                return AnyShape(RoundedCorner(radius: CarouselConfiguration.cornerRadius, corners: [.topRight, .bottomRight]))
            }
        } else {
            // When there's spacing, all corners can be rounded
            return AnyShape(RoundedRectangle(cornerRadius: CarouselConfiguration.cornerRadius))
        }
    }
}
