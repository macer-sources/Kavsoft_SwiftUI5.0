//
//  Helpers.swift
//  A_97_SwiftUI-Scrollable-Tab-Bar
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

/**
 接下来，我们需要一种插值技术，它将  输入范围设置为给定的输出范围值。为  例如，进度 0.5 将映射为 10，而  输入范围为 [0， 0.5， 1]，输出范围为 [0， 10， 15]。  请注意，输入和输出范围数组  计数必须匹配才能使此函数正常工作。
 */
extension CGFloat {
    func interpolate(inputRange: [CGFloat], outRange:[CGFloat]) -> CGFloat {
        // is vlaue less than it's initial input range
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] {return outRange[0]}
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outRange[index - 1]
            let y2 = outRange[index]
            
            // liner interpolation formula: y1 + ((y2 - y1) / (x2 - x2)) * (x - x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x  - x1)
                return y
            }
        }
        return outRange[length]
    }
}


struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


extension View {
    @ViewBuilder
    func rect(completion:@escaping (CGRect) -> Void) -> some View {
        self
            .overlay {
            GeometryReader(content: { geometry in
                let rect = geometry.frame(in: .scrollView(axis: .horizontal))
                
                Color
                    .clear
                    .preference(key: RectKey.self, value: rect)
                    .onPreferenceChange(RectKey.self) { value in
                    debugPrint("[DEBUG]: onPreferenceChange:\(value)")
                    completion(value)
                }
            })
        }
    }
}
