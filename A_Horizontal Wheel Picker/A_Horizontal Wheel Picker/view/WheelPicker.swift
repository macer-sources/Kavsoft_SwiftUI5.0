//
//  WheelPicker.swift
//  A_Horizontal Wheel Picker
//
//  Created by Kan Tao on 2024/3/19.
//

import SwiftUI

struct WheelPicker: View {
    var config: Config
    @Binding var value: CGFloat
    
    // view properties
    @State private var isLoaded: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let horizontalPadding = size.width  / 2
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing, content: {
                    let totalSteps = config.steps * config.count
                    
                    ForEach(0...totalSteps, id:\.self) {index in
                        let remainder = index % config.steps
                        
                            Divider()
                            .background(remainder == 0 ? Color.primary : .gray)
                            .frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
                            .frame(maxHeight: 20, alignment: .bottom)
                            // 显示文字
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showText {
                                    Text("\((index / config.steps) * config.multiplier)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize() // 没有这个东西 文字不显示？
                                        .offset(y: 20)
                                }
                            }
                    }
                })
                .frame(height: size.height)
                .scrollTargetLayout() // 这里的作用是什么？
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                let position:Int? = isLoaded ? (Int(value) * config.steps) / config.multiplier : nil
                return position
            }, set: { newValue in
                if let newValue {
                    value = CGFloat(CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            //最长的那根指标线
            .overlay(alignment: .center, content: {
                Rectangle()
                    .frame(width: 1, height: 40)
                    .padding(.bottom, 20)
            })
            .safeAreaPadding(.horizontal, horizontalPadding) // 设置左右两边的偏移量
            .onAppear(perform: {
                if !isLoaded {isLoaded = true}
            })
        })
    }
    
    struct Config: Equatable {
        var count: Int
        var steps:Int = 10
        var spacing: CGFloat = 5
        var multiplier: Int = 10
        var showText: Bool = true
    }
    
}

#Preview {
    ContentView()
}
