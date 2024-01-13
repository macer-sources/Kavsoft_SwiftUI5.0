//
//  View+Exts.swift
//  A_48_Building Scrollable Tab View
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI


// offset key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


extension View {
    @ViewBuilder
    func offsetX(completion:@escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader(content: { geometry in
                let minX = geometry.frame(in: .scrollView(axis: .horizontal)).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform:completion)
            })
        }
    }
    
        
    // tab bar masking
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self.symbolVariant(.fill)
                .mask {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x: tabProgress * (size.width - capusleWidth))
                    })
                }
            
        }
    }
    
}



#Preview {
    ContentView()
}
