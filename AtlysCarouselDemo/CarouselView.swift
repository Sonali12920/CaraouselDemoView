//
//  CarouselView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Carousel Configuration
struct CarouselConfiguration {
    static let spacing: CGFloat = 0
    static let aspectRatio: CGFloat = 1.0
    static let centerScale: CGFloat = 1.2
    static let sideScale: CGFloat = 0.8
    static let sideOpacity: CGFloat = 0.6
    static let cardPadding: CGFloat = 40
    static let cornerRadius: CGFloat = 16
    static let paginationDotSize: CGFloat = 8
    static let paginationDotSpacing: CGFloat = 8
    static let carouselHeight: CGFloat = 280
    static let imageHeightRatio: CGFloat = 0.7
    static let titleLeadingPadding: CGFloat = 8
    static let subtitlePadding: CGFloat = 8
    static let overlayBottomPadding: CGFloat = 20
    static let overlaySpacing: CGFloat = 2
}

// MARK: - Carousel State Management
class CarouselState: ObservableObject {
    @Published var activeIndex: Int = 0
    @Published var dragOffset: CGFloat = 0
    @Published var currentPage: Int = 0
    
    func updatePage() {
        currentPage = activeIndex
    }
    
    func navigateToPage(_ page: Int) {
        activeIndex = page
        currentPage = page
    }
}

// MARK: - Main Carousel View
struct CarouselView: View {
    @StateObject private var viewModel = CarouselViewModel()
    @StateObject private var carouselState = CarouselState()
    
    var body: some View {
        VStack(spacing: 16) {
            carouselContent
            paginationIndicator
        }
        .padding(.horizontal, 8)
        .onAppear(perform: setupInitialState)
    }
    
    // MARK: - Carousel Content
    private var carouselContent: some View {
        GeometryReader { geometry in
            let layout = CarouselLayout(geometry: geometry)
            
            ZStack {
                backgroundView(layout: layout)
                carouselItems(layout: layout)
            }
            .frame(height: layout.cardHeight)
        }
        .frame(height: CarouselConfiguration.carouselHeight)
    }
    
    private func backgroundView(layout: CarouselLayout) -> some View {
        Color.clear
            .frame(width: layout.screenWidth, height: layout.cardHeight)
    }
    
    private func carouselItems(layout: CarouselLayout) -> some View {
        HStack(spacing: CarouselConfiguration.spacing) {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                CarouselItemView(
                    item: item,
                    index: index,
                    activeIndex: carouselState.activeIndex,
                    layout: layout
                )
                .scaleEffect(getScale(for: index))
                .opacity(getOpacity(for: index))
            }
        }
        .offset(x: calculateOffset(layout: layout))
        .frame(width: layout.screenWidth, alignment: .leading)
        .gesture(createDragGesture(layout: layout))
    }
    
    // MARK: - Pagination Indicator
    private var paginationIndicator: some View {
        HStack(spacing: CarouselConfiguration.paginationDotSpacing) {
            ForEach(0..<viewModel.items.count, id: \.self) { index in
                PaginationDot(
                    isActive: carouselState.currentPage == index,
                    onTap: { navigateToPage(index) }
                )
            }
        }
    }
    
    // MARK: - Layout Calculations
    private func getScale(for index: Int) -> CGFloat {
        let distance = abs(index - carouselState.activeIndex)
        switch distance {
        case 0: return CarouselConfiguration.centerScale
        case 1: return CarouselConfiguration.sideScale
        default: return CarouselConfiguration.sideScale * 0.9
        }
    }
    
    private func getOpacity(for index: Int) -> CGFloat {
        let distance = abs(index - carouselState.activeIndex)
        switch distance {
        case 0: return 1.0
        case 1: return CarouselConfiguration.sideOpacity
        default: return CarouselConfiguration.sideOpacity * 0.5
        }
    }
    
    private func calculateOffset(layout: CarouselLayout) -> CGFloat {
        let centerOffset = CGFloat(carouselState.activeIndex) * -layout.totalCardWidth
        let screenCenter = layout.screenWidth / 2
        let imageCenter = layout.totalCardWidth / 2
        let adjustment = screenCenter - imageCenter
        return centerOffset + adjustment + carouselState.dragOffset
    }
    
    // MARK: - Gesture Handling
    private func createDragGesture(layout: CarouselLayout) -> some Gesture {
        DragGesture()
            .onChanged { value in
                carouselState.dragOffset = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(value: value, layout: layout)
            }
    }
    
    private func handleDragEnd(value: DragGesture.Value, layout: CarouselLayout) {
        let dragThreshold = layout.cardWidth / 3
        let predictedEnd = value.predictedEndTranslation.width
        
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
            if value.translation.width < -dragThreshold || predictedEnd < -layout.cardWidth {
                carouselState.activeIndex = min(carouselState.activeIndex + 1, viewModel.items.count - 1)
            } else if value.translation.width > dragThreshold || predictedEnd > layout.cardWidth {
                carouselState.activeIndex = max(carouselState.activeIndex - 1, 0)
            }
            carouselState.dragOffset = 0
        }
        
        carouselState.updatePage()
        provideHapticFeedback()
    }
    
    private func navigateToPage(_ page: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            carouselState.navigateToPage(page)
        }
        provideHapticFeedback()
    }
    
    // MARK: - Setup
    private func setupInitialState() {
        carouselState.activeIndex = 0
        carouselState.currentPage = 0
    }
    
    private func provideHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Pagination Dot
struct PaginationDot: View {
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Circle()
            .fill(isActive ? Color.purple : Color.gray.opacity(0.3))
            .frame(width: CarouselConfiguration.paginationDotSize, height: CarouselConfiguration.paginationDotSize)
            .scaleEffect(isActive ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
            .onTapGesture(perform: onTap)
    }
}

// MARK: - Rounded Corner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


