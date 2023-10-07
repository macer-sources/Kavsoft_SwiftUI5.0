//
//  MAnchorKey.swift
//  A_20_NavigationStack Hero Animation Effect
//
//  Created by Kan Tao on 2023/10/7.
//

import SwiftUI

// For Reading the Source and Destination View Bounds for our Custom Mathed Geometry Effert
struct MAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) {$1}
    }
    
}
