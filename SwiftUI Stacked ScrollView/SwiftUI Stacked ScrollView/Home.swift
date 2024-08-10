//
//  Home.swift
//  SwiftUI Stacked ScrollView
//
//  Created by Kan Tao on 2024/6/3.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            
            StackedCards(items: items,stackedDisplayCount: 1, itemHeight: 70) { item in
                CardView(item)
            }
            
            BottomActionBar()
        }
        .padding(20)
    }
    
    // bottom action bar
    @ViewBuilder
    func BottomActionBar() -> some View {
        HStack {
            Button(action: {}, label: {
                Image(systemName: "flashlight.off.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            })
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
            
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            })
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
        }
    }
    
    
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        HStack(spacing: 12, content: {
            RoundedRectangle(cornerRadius: 4)
                .fill(item.logo)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.title)
                    .font(.callout)
                    .fontWeight(.bold)
                
                Text(item.description)
                    .font(.caption)
                    .lineLimit(1)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        })
        .padding(10)
        .frame(maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
    }
    
}

struct StackedCards<Content: View, Data: RandomAccessCollection>: View  where Data.Element: Identifiable{
    
    var items: Data
    var stackedDisplayCount: Int = 2
    var spacing: CGFloat = 5
    var itemHeight: CGFloat
    @ViewBuilder var content:(Data.Element) -> Content
    
    var body: some View {
        GeometryReader(content: {
            let size = $0.size
            
            ScrollView(.vertical) {
                VStack(spacing: spacing) {
                    ForEach(items) {item in
                        content(item)
                            .frame(height: itemHeight)
                            .visualEffect { content, geometryProxy in
                                content
                                    .scaleEffect(scale(geometryProxy))
                                    .offset(y: offset(geometryProxy))
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        })
    }
    
    
    // offset & scaling values for each item to make it look like a stack
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        return 0
    }
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        return 0
    }
}


#Preview {
    ContentView()
}



