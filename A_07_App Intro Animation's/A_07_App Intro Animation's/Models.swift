//
//  Models.swift
//  A_07_App Intro Animation's
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Intro: Identifiable {
    var id:UUID = .init()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}



// sample intros
var sampleIntros:[Intro] = [
    .init(text: "Let's Create", textColor: .color4, circleColor: .color4, bgColor: .color1),
    .init(text: "Let's Brain Strom", textColor: .color1, circleColor: .color1, bgColor: .color2),
    .init(text: "Let's Explore", textColor: .color2, circleColor: .color2, bgColor: .color3),
    
    .init(text: "Let's Invent", textColor: .color3, circleColor: .color3, bgColor: .color4),
    
    .init(text: "Let's Create", textColor: .color4, circleColor: .color4, bgColor: .color1),
        
]


