//
//  CarouselView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI





// MARK: - Main Carousel View
struct CarouselView: View {
    @StateObject private var viewModel = CarouselViewModel()
    @StateObject private var carouselState = CarouselState()
    
    var body: some View {
        VStack(spacing: 16) {
            CarouselContentView(
                items: viewModel.items,
                carouselState: carouselState
            )
            PaginationView(
                itemCount: viewModel.items.count,
                currentPage: carouselState.currentPage,
                onPageSelected: { page in
                    carouselState.navigateToPage(page)
                }
            )
        }
        .padding(.horizontal, 8)
        .onAppear(perform: setupInitialState)
    }
    
    private func setupInitialState() {
        carouselState.activeIndex = 0
        carouselState.currentPage = 0
    }
}

// MARK: - Carousel Content View
struct CarouselContentView: View {
    let items: [CarouselItem]
    @ObservedObject var carouselState: CarouselState
    
    var body: some View {
        GeometryReader { geometry in
            let layout = CarouselLayout(geometry: geometry)
            
            ZStack {
                CarouselItemsView(
                    items: items,
                    carouselState: carouselState,
                    layout: layout
                )
            }
            .frame(height: layout.cardHeight)
        }
        .frame(height: CarouselConfiguration.carouselHeight)
    }
}

// MARK: - Carousel Items View
struct CarouselItemsView: View {
    let items: [CarouselItem]
    @ObservedObject var carouselState: CarouselState
    let layout: CarouselLayout
    
    var body: some View {
        HStack(spacing: CarouselConfiguration.spacing) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                CarouselItemView(
                    item: item,
                    index: index,
                    activeIndex: carouselState.activeIndex,
                    layout: layout
                )
                .scaleEffect(CarouselEffects.getScale(for: index, activeIndex: carouselState.activeIndex))
                .opacity(CarouselEffects.getOpacity(for: index, activeIndex: carouselState.activeIndex))
            }
        }
        .offset(x: CarouselOffsetCalculator.calculateOffset(
            activeIndex: carouselState.activeIndex,
            dragOffset: carouselState.dragOffset,
            layout: layout
        ))
        .frame(width: layout.screenWidth, alignment: .leading)
        .gesture(CarouselGestureHandler.createDragGesture(
            carouselState: carouselState,
            itemCount: items.count,
            layout: layout
        ))
    }
}






