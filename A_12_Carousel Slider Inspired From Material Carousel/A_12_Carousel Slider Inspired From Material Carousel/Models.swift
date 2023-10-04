//
//  Models.swift
//  A_12_Carousel Slider Inspired From Material Carousel
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Card: Identifiable, Hashable, Equatable {
    var id: UUID = UUID.init()
    var image: String
    var previousOffset: CGFloat = 0
}
