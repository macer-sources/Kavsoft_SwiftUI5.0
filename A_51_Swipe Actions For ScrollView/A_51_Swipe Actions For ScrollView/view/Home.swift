//
//  Home.swift
//  A_51_Swipe Actions For ScrollView
//
//  Created by Kan Tao on 2024/1/14.
//

import SwiftUI

struct Home: View {
    
    @State private var colors:[Color] = [.black, .yellow, .purple, .brown]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(content: {
                ForEach(colors, id: \.self) { color in
                    SimpleCardView(color)
                }
            })
        }
        .scrollIndicators(.hidden)
    }
}

extension Home {
    @ViewBuilder
    private func SimpleCardView(_ color: Color) -> some View {
        HStack(spacing: 12, content: {
            Circle()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 6, content: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 5)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 5)
            })
            
            Spacer()
        })
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
    }
}







#Preview {
    ContentView()
}
