//
//  CarouselItem.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 11/07/25.
//

import Foundation

struct CarouselItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}
