//
//  CustomSlider.swift
//  A75_Stretchy Slider Like
//
//  Created by Kan Tao on 2024/2/8.
//

import SwiftUI



struct CustomSlider: View {
    @Binding var sliderProgress: CGFloat
    // Configuration
    var symbol: Symbol?
    var axis: SliderAxis
    var tint: Color
    
    @State private var progress: CGFloat = 0
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            // TODO: 通过这里
            let origntationSize = axis == .horizontal ? size.width : size.height
            let progressValue = (max(progress, .zero)) * origntationSize
            
            
            ZStack(alignment: axis == .horizontal ? .leading : .bottom, content: {
                Rectangle()
                    .fill(.fill)
                
                Rectangle()
                    .fill(tint)
                    .frame(width: axis == .horizontal ? progressValue : nil,
                           height: axis == .vertical ? progressValue : nil)
                
                if let symbol, symbol.display {
                    Image(systemName: symbol.icon)
                        .font(symbol.font)
                        .foregroundStyle(symbol.tint)
                        .padding(symbol.padding)
                        .frame(width: size.width, height: size.height, alignment: symbol.alignment)
                }
                
            })
            .clipShape(.rect(cornerRadius: 15))
            .contentShape(.rect(cornerRadius: 15))
            .optionalSizingModifiers(axis: axis, size: size, progress: progress, oriemtationSize: origntationSize)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        let translation = value.translation
                        let movement = (axis == .horizontal ? translation.width : -translation.height) + lastDragOffset
                        dragOffset = movement
                        calculateProgress(origntationSize: origntationSize)
                    })
                    .onEnded({ value in
                        
                        withAnimation(.smooth) {
                            
                            dragOffset = dragOffset > origntationSize ? origntationSize : (dragOffset < 0 ? 0 : dragOffset)
                            calculateProgress(origntationSize: origntationSize)
                        }
                        
                        lastDragOffset = dragOffset
                    })
            )
            .frame(maxWidth: size.width,
                   maxHeight: size.height,
                   alignment: axis == .vertical ? (progress < 0 ? .top : .bottom) :  (progress < 0 ? .trailing : .leading )
             )
            .onChange(of: sliderProgress, initial: true) { oldValue, newValue in
                // initial progress setting
                guard sliderProgress != progress, (sliderProgress > 0 && sliderProgress < 1) else {return}
                progress = max(min(sliderProgress, 1.0), .zero)
                dragOffset = progress * origntationSize
                lastDragOffset = dragOffset
            }
            .onChange(of: axis) { oldValue, newValue in
                dragOffset = progress * origntationSize
                lastDragOffset = dragOffset
            }
        })
        .onChange(of: progress) { oldValue, newValue in
            sliderProgress = max(min(progress, 1.0), .zero)
        }
    }
}


extension CustomSlider {
    // calculating progress
    private func calculateProgress(origntationSize: CGFloat) {
        let topAndTrailingExcessOffset = origntationSize + (dragOffset - origntationSize) * 0.15 // 0.15 可以根据需要更改，drag 超出的部分
        let bottomAndLeadingExcessOffset = dragOffset < 0 ? (dragOffset * 0.15) : dragOffset
        let pregress = (dragOffset > origntationSize ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / origntationSize
        self.progress = pregress > 1.1 ? 1.1 : progress
    }
}

extension CustomSlider {
    struct Symbol {
        var icon: String
        var tint: Color
        var font: Font
        var padding: CGFloat
        var display: Bool = true
        var alignment: Alignment = .center
    }
    
    enum SliderAxis {
        case vertical
        case horizontal
    }
}

fileprivate extension View {
    @ViewBuilder
    func optionalSizingModifiers(axis: CustomSlider.SliderAxis , size: CGSize , progress: CGFloat, oriemtationSize: CGFloat) -> some View {
        let topAndTrailingScale = 1 - (progress - 1) * 0.25
        let bottomAndLeadingScale = 1 + (progress) * 0.25
        self
            .frame(
                width: axis ==  .horizontal && progress < 0 ? size.width + (-progress * size.width) : nil,
                height: axis ==  .vertical && progress < 0 ? size.height + (-progress * size.height) : nil)
            .scaleEffect(x:
                            axis == .vertical ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                         y: axis == .horizontal ? (progress > 1 ? topAndTrailingScale : (progress < 0 ? bottomAndLeadingScale : 1)) : 1,
                         anchor: axis == .horizontal ? (progress < 0 ?  .trailing : .leading) : (progress < 0 ? .top : .bottom))
    }
}


#Preview {
    ContentView()
}
