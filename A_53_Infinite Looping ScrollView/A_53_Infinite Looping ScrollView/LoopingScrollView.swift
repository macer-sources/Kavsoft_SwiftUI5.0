//
//  LoopingScrollView.swift
//  A_53_Infinite Looping ScrollView
//
//  Created by Kan Tao on 2024/6/16.
//

import SwiftUI

struct LoopingScrollView<Content:View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var width: CGFloat
    var spacing: CGFloat = 0
    var items:Item
    @ViewBuilder var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            // Saftey check
            let repeatingCount = width > 0 ?  Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    ForEach(items) {item in
                        content(item)
                            .frame(width: width)
                    }
                    
                    ForEach(0..<repeatingCount, id:\.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .frame(width: width)
                    }
                    
                }
                .background {
                    ScrollViewHepler(width: width,
                                     spacing: spacing,
                                     itemCount: items.count,
                                     repeatingCount: repeatingCount)
                }
            }
        }
    }
}


fileprivate struct ScrollViewHepler: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isAdded = true
            }
        }
        context.coordinator.width = width
        context.coordinator.spacing = spacing
        context.coordinator.itemCount = itemCount
        context.coordinator.repeatingCount = repeatingCount
    }
    
    var width: CGFloat
    var spacing: CGFloat
    var itemCount: Int
    var repeatingCount: Int
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(width: width,
                    spacing: spacing,
                    itemCount: itemCount,
                    repeatingCount: repeatingCount)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemCount: Int
        var repeatingCount: Int
        var isAdded: Bool = false
        
        init(width: CGFloat, spacing: CGFloat, itemCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemCount = itemCount
            self.repeatingCount = repeatingCount
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemCount >  0 else {return}
            let minX = scrollView.contentOffset.x
            
            let mainContentSize = CGFloat(itemCount)  * width
            let spacingSize = CGFloat(itemCount) * spacing
            
            if minX > (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            if minX < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
        }
    }
    
}



#Preview {
    ContentView()
}
