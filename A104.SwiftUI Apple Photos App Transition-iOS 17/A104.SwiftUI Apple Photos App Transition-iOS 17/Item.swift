//
//  Item.swift
//  A104.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/6.
//

import Foundation
import SwiftUI



struct Item: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
    var image: UIImage?
    var previewImage: UIImage?
    var appeared: Bool = false
}


var sampleItems:[Item] = [
    .init(title: "Fanny Hagan", image: UIImage.init(named: "image1")),
    .init(title: "Han-Chieh Lee", image: UIImage.init(named: "image2")),
    .init(title: "Fanny", image: UIImage.init(named: "image3")),
    .init(title: "Abril Altamirano", image: UIImage.init(named: "image4")),
    .init(title: "introduced the", image: UIImage.init(named: "image5")),
    .init(title: "and awai", image: UIImage.init(named: "image6")),
    .init(title: " tasks using", image: UIImage.init(named: "image7")),
    .init(title: "heterogeneous", image: UIImage.init(named: "image8")),
    .init(title: "demonstrate", image: UIImage.init(named: "image9")),
    .init(title: "different", image: UIImage.init(named: "image10")),
    .init(title: "async functions", image: UIImage.init(named: "image11")),
]
