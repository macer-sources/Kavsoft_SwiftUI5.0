//
//  Home.swift
//  A_12_Carousel Slider Inspired From Material Carousel
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Home: View {
    @State private var cards:[Card] = [
        .init(image: "image1"),
        .init(image: "image2"),
        .init(image: "image3"),
        .init(image: "image4"),
        .init(image: "image5"),
        .init(image: "image6"),
    ]
    
    var body: some View {
        VStack(content: {
            ScrollView(.horizontal) {
                HStack(spacing: 10, content: {
                    ForEach(cards) {card in
                            CardView(card)
                    }
                })
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .clipShape(.rect(cornerRadius: 25))
            .padding(.horizontal, 15)
            .padding(.top, 30)
            
            Spacer()
        })
    }
    
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            let minX = geometry.frame(in: .scrollView).minX
            let reducingWidth = (minX / 190 ) * 130
            let cappedWidth = min(reducingWidth, 130)
 
            // (minX > 0 ? cappedWidth : -cappedWidth) 重要
            let frameWidth = size.width - (minX > 0 ? cappedWidth : -cappedWidth)
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth < 0 ? 0 : frameWidth)
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
                .offset(x: minX > 0 ? 0 : -cappedWidth)// TODO: 重要
                .offset(x: -card.previousOffset)
        })
        .frame(width: 180, height: 200)
        .offsetX { offset in
            let reducingWidth = (offset / 190 ) * 130
            let index = cards.indexOf(card)
            
            if cards.indices.contains(index + 1) {
                cards[index + 1].previousOffset = (offset < 0 ? 0 : reducingWidth)
            }
        }
    }
    
}

#Preview {
    ContentView()
}



struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat =  0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


extension View {
    @ViewBuilder
    func offsetX(completion:@escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader(content: { geometry in
                let minX = geometry.frame(in: .scrollView).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        completion(value)
                    })
            })
        }
    }
}

extension [Card] {
    func indexOf(_ card: Card) -> Int {
        return self.firstIndex(of: card) ?? 0
    }
}

