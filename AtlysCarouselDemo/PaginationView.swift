//
//  PaginationView.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 10/07/25.
//

import SwiftUI

// MARK: - Pagination View
struct PaginationView: View {
    let itemCount: Int
    let currentPage: Int
    let onPageSelected: (Int) -> Void
    
    var body: some View {
        HStack(spacing: CarouselConfiguration.paginationDotSpacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                PaginationDot(
                    isActive: currentPage == index,
                    onTap: { onPageSelected(index) }
                )
            }
        }
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