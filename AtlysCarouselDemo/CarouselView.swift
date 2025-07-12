//
//  CarouselView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

struct CarouselView: View {
    @StateObject private var viewModel = CarouselViewModel()
    @State private var activeIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    // Layout constants
    private let spacing: CGFloat = 20
    private let cardAspectRatio: CGFloat = 1.0
    private let centerCardScale: CGFloat = 1.2
    private let sideCardScale: CGFloat = 0.8
    private let sideCardOpacity: CGFloat = 0.6
    private let cardPadding: CGFloat = 40 // Space on sides when card is centered
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width - (cardPadding * 2)
            let cardHeight = cardWidth * cardAspectRatio
            let totalCardWidth = cardWidth + spacing
            
            ZStack {
                // Background for visible area
                Color.clear
                    .frame(width: geometry.size.width, height: cardHeight)
                
                // Carousel items with circular scrolling
                HStack(spacing: spacing) {
                    ForEach(0..<viewModel.items.count * 3, id: \.self) { index in
                        let actualIndex = index % viewModel.items.count
                        let item = viewModel.items[actualIndex]
                        
                        CarouselItemView(
                            item: item,
                            isActive: isItemActive(index: index),
                            cardWidth: cardWidth,
                            cardHeight: cardHeight
                        )
                        .scaleEffect(getScaleForIndex(index: index))
                        .opacity(getOpacityForIndex(index: index))
                    }
                }
                .offset(x: calculateOffset(geometry: geometry, totalCardWidth: totalCardWidth))
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            handleDragEnd(value: value, cardWidth: cardWidth, totalCardWidth: totalCardWidth)
                        }
                )
            }
            .frame(height: cardHeight)
        }
        .frame(height: 280) // Increased height for better visibility
        .padding(.horizontal, 8)
        .onAppear {
            // Start at the middle set of items for circular scrolling
            activeIndex = viewModel.items.count
        }
    }
    
    private func isItemActive(index: Int) -> Bool {
        return index == activeIndex
    }
    
    private func getScaleForIndex(index: Int) -> CGFloat {
        let distance = abs(index - activeIndex)
        if distance == 0 {
            return centerCardScale
        } else if distance == 1 {
            return sideCardScale
        } else {
            return sideCardScale * 0.9
        }
    }
    
    private func getOpacityForIndex(index: Int) -> CGFloat {
        let distance = abs(index - activeIndex)
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return sideCardOpacity
        } else {
            return sideCardOpacity * 0.5
        }
    }
    
    private func calculateOffset(geometry: GeometryProxy, totalCardWidth: CGFloat) -> CGFloat {
        let centerOffset = CGFloat(activeIndex) * -totalCardWidth
        let screenCenter = geometry.size.width / 2
        let cardCenter = (geometry.size.width - cardPadding * 2) / 2
        let adjustment = screenCenter - cardCenter
        return centerOffset + adjustment + dragOffset
    }
    
    private func handleDragEnd(value: DragGesture.Value, cardWidth: CGFloat, totalCardWidth: CGFloat) {
        let dragThreshold = cardWidth / 3
        let predictedEnd = value.predictedEndTranslation.width
        
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
            if value.translation.width < -dragThreshold || predictedEnd < -cardWidth {
                activeIndex += 1
                // Handle circular scrolling
                if activeIndex >= viewModel.items.count * 2 {
                    activeIndex = viewModel.items.count
                }
            } else if value.translation.width > dragThreshold || predictedEnd > cardWidth {
                activeIndex -= 1
                // Handle circular scrolling
                if activeIndex < viewModel.items.count {
                    activeIndex = viewModel.items.count * 2 - 1
                }
            }
            dragOffset = 0
        }
        impactFeedback(style: .light)
    }
    
    private func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct CarouselItemView: View {
    let item: CarouselItem
    let isActive: Bool
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight * 0.8) // 80% of height for image
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: isActive ? 3 : 1)
                )
                .shadow(radius: isActive ? 10 : 5)
            
            VStack(spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isActive ? .primary : .secondary)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: cardWidth)
        }
        .frame(width: cardWidth, height: cardHeight)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
    }
}
