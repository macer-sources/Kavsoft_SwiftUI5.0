//
//  Card.swift
//  A_47_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID.init()
    var bgColor: Color
    var balance: String
}


var cards:[Card] = [
    .init(bgColor: .red, balance: "$125,000"),
    .init(bgColor: .blue, balance: "$25,000"),
    .init(bgColor: .darkOrange, balance: "$25,000"),
    .init(bgColor: .purple, balance: "$5,000")
]
