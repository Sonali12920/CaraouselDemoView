////
////  CarouselItemView.swift
////  AtlysCarouselDemo
////
////  Created by Sonali on 10/07/25.
////
//
//import Foundation
//import SwiftUI
//
//struct CarouselItemView: View {
//    @EnvironmentObject var carouselState: CarouselState
//    let id: Int
//    let spacing: CGFloat
//    let widthOfHiddenCards: CGFloat
//    let cardHeight: CGFloat
//    let item: CarouselItem
//    let isActive: Bool
//    
//    var body: some View {
//        let cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
//        
//        VStack(spacing: 8) {
//            Image(item.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(width: cardWidth, height: isActive ? cardHeight - 60 : cardHeight - 100)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.white, lineWidth: 2)
//                )
//                .shadow(radius: 5)
//            
//            VStack(spacing: 4) {
//                Text(item.title)
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Text(item.subtitle)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//        .frame(width: cardWidth, height: isActive ? cardHeight : cardHeight - 40)
//        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
//    }
//}
