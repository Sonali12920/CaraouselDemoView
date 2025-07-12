
//
//  CarouselViewModel.swift
//  AtlysCarouselDemo
//
//  Created by Sonali on 11/07/25.
//

import Foundation
import SwiftUI

final class CarouselViewModel: ObservableObject {
    let items: [CarouselItem] = [
        CarouselItem(imageName: "img1", title: "Dubai", subtitle: "52k visas approved"),
        CarouselItem(imageName: "img2", title: "Thailand", subtitle: "32k visas approved"),
        CarouselItem(imageName: "img3", title: "Singapore", subtitle: "28k visas approved"),
        CarouselItem(imageName: "img1", title: "Malaysia", subtitle: "45k visas approved"),
        CarouselItem(imageName: "img2", title: "Vietnam", subtitle: "38k visas approved")
    ]
}
