//
//  ContentView.swift
//  A_99_SwiftUI Range Slider_Xcode 16
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    @State private var selection:ClosedRange<CGFloat> = 30...50
    
    var body: some View {
        NavigationStack {
            VStack {
                RangeSliderView(selection: $selection, range: 30...100,minimumDistance: 0)
                Text("\(Int(selection.lowerBound)) : \(Int(selection.upperBound))")
                    .font(.largeTitle.bold())
                    .padding(.top, 10)
            }
            .padding()
            .navigationTitle("Range Slider")
        }
    }
}


// custom  view
struct RangeSliderView: View {
    @Binding var selection:ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primary
    
    // view properties
    @State private var slider1 = GestureProperties()
    @State private var slider2 = GestureProperties()
    
    @State private var indicatorWidth: CGFloat = 0
    
    
    @State private var isInitial: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let maxSliderWidth = geometry.size.width - 30 // 两个circle 的宽度
            let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            
            ZStack(alignment: .leading, content: {
                Capsule()
                    .fill(.tint.tertiary)
                    .frame(height: 5)
                // sliders
                HStack(spacing: 0, content: {
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .overlay(alignment: .leading, content: {
                            Rectangle()
                                .fill(.tint)
                                .offset(x: 15)
                                .frame(width: indicatorWidth, height: 5)
                                .allowsHitTesting(false)
                        })
                        .offset(x: slider1.offset)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                // calculating offset
                                var translation = value.translation.width + slider1.lastStoreOffset
                                translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                slider1.offset = translation
                                
                                calculateNewRange(geometry.size)
                            }).onEnded({ _ in
                                // storing previous offset
                                slider1.lastStoreOffset = slider1.offset
                            }))
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .offset(x: slider2.offset)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                var translation = value.translation.width + slider2.lastStoreOffset
                                translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                                slider2.offset = translation
                                
                                calculateNewRange(geometry.size)
                            }).onEnded({ _ in
                                slider2.lastStoreOffset = slider2.offset
                            }))
                    
                })
            })
            .frame(maxHeight: .infinity)
            .task {
                guard !isInitial else { return }
                isInitial = true
                try? await Task.sleep(for: .seconds(0))
                let maxWidth = geometry.size.width - 30
                
                // coverting selection range into offset
                let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outRange: [0, maxWidth])
                let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outRange: [0, maxWidth])
                
                slider1.offset = start
                slider1.lastStoreOffset = start
                
                slider2.offset = end
                slider2.lastStoreOffset = end
                
                calculateNewRange(geometry.size)
            }
        })
        .frame(height: 15)
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        // calculating new range value
        let maxWidth = size.width - 30
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        
        // interpolating between upper and lower bounds
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        // updating selection
        selection = newRangeStart...newRangeEnd
        
    }
    
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoreOffset: CGFloat = 0
    }
    
}


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


#Preview {
    ContentView()
}
