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
    @State private var currentPage: Int = 0
    
    // Layout constants
    private let spacing: CGFloat = 0
    private let cardAspectRatio: CGFloat = 1.0
    private let centerCardScale: CGFloat = 1.2
    private let sideCardScale: CGFloat = 0.8
    private let sideCardOpacity: CGFloat = 0.6
    private let cardPadding: CGFloat = 40 // Space on sides when card is centered
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                let cardWidth = geometry.size.width - (cardPadding * 2)
                let cardHeight = cardWidth * cardAspectRatio
                let imageWidth = cardWidth * 0.9
                let totalCardWidth = imageWidth
                
                ZStack {
                    // Background for visible area
                    Color.clear
                        .frame(width: geometry.size.width, height: cardHeight)
                    
                                    // Carousel items
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        let item = viewModel.items[index]
                        
                        CarouselItemView(
                            item: item,
                            isActive: isItemActive(index: index),
                            cardWidth: imageWidth,
                            cardHeight: cardHeight,
                            index: index,
                            activeIndex: activeIndex
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
            .frame(height: 280)
            
            // Pagination dots
            HStack(spacing: 8) {
                ForEach(0..<viewModel.items.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.purple : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                navigateToPage(index)
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            activeIndex = 0
            currentPage = 0
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
        let imageCenter = totalCardWidth / 2
        let adjustment = screenCenter - imageCenter
        return centerOffset + adjustment + dragOffset
    }
    
    private func handleDragEnd(value: DragGesture.Value, cardWidth: CGFloat, totalCardWidth: CGFloat) {
        let dragThreshold = cardWidth / 3
        let predictedEnd = value.predictedEndTranslation.width
        
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
            if value.translation.width < -dragThreshold || predictedEnd < -cardWidth {
                activeIndex = min(activeIndex + 1, viewModel.items.count - 1)
            } else if value.translation.width > dragThreshold || predictedEnd > cardWidth {
                activeIndex = max(activeIndex - 1, 0)
            }
            dragOffset = 0
        }
        
        // Update current page
        updateCurrentPage()
        impactFeedback(style: .light)
    }
    
    private func navigateToPage(_ page: Int) {
        activeIndex = page
        currentPage = page
        impactFeedback(style: .light)
    }
    
    private func updateCurrentPage() {
        currentPage = activeIndex
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
    let index: Int
    let activeIndex: Int
    
    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: cardWidth, height: cardHeight * 0.7) // Use full cardWidth since it's already the image width
            .clipped()
            .clipShape(getCornerRadius())
            .overlay(
                VStack(alignment: .leading, spacing: 2) {
                    Spacer()
                    Spacer()
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .lineLimit(1)
                        .padding(.leading, 8)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple)
                        .cornerRadius(4)
                        .padding(.leading, 0)
                }
                .padding(.bottom, 20),
                alignment: .leading
            )
        .frame(width: cardWidth, height: cardHeight)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
    }
    
    private func getCornerRadius() -> AnyShape {
        let distance = abs(index - activeIndex)
        
        if distance == 0 {
            // Center image - all corners rounded
            return AnyShape(RoundedRectangle(cornerRadius: 16))
        } else if distance == 1 {
            // Side images - connected sides have 0 radius, outer sides have 16pt radius
            if index < activeIndex {
                // Left image - left side (connected to center) has 0 radius, right side has 16pt radius
                return AnyShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
            } else {
                // Right image - right side (connected to center) has 0 radius, left side has 16pt radius
                return AnyShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
            }
        } else {
            // Further images - all corners rounded
            return AnyShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


