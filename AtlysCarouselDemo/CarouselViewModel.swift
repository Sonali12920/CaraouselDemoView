
//
//  CarouselViewModel.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 11/07/25.
//

import Foundation
import SwiftUI

final class CarouselViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var dragOffset: CGFloat = 0
    
    let items: [CarouselItem] = [
        CarouselItem(imageName: "img1", title: "Dubai", subtitle: "52k visas approved"),
        CarouselItem(imageName: "img2", title: "Thailand", subtitle: "32k visas approved"),
        CarouselItem(imageName: "img3", title: "Singapore", subtitle: "28k visas approved"),
        CarouselItem(imageName: "img1", title: "Malaysia", subtitle: "45k visas approved"),
        CarouselItem(imageName: "img2", title: "Vietnam", subtitle: "38k visas approved")
    ]
    
    func calculateNewPage(gestureWidth: CGFloat, cardWidth: CGFloat, cardPadding: CGFloat) {
        let totalDragWidth = cardWidth + cardPadding
        let offset = gestureWidth / totalDragWidth
        withAnimation(.spring()) {
            currentPage = max(0, min(items.count - 1, Int(CGFloat(currentPage) - offset.rounded())))
        }
    }
}
