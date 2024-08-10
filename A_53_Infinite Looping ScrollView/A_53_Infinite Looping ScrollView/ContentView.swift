//
//  ContentView.swift
//  A_53_Infinite Looping ScrollView
//
//  Created by Kan Tao on 2024/6/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Home")
        }
      
    }
}


struct Home: View {
    @State private var items: [Item] =
        [.red, .blue, .green,.yellow,.black].compactMap({return .init(color: $0)})
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                GeometryReader {
                    let size = $0.size
                    
                    LoopingScrollView(width: size.width,spacing: 0, items: items) { item in
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(item.color.gradient)
                        RoundedRectangle(cornerRadius: 15)
                                  .fill(item.color.gradient)
                                  .padding(.horizontal, 15)
                    }
                    // 添加 padding
//                    .contentMargins(.horizontal, 15, for: .scrollContent)
                    .scrollTargetBehavior(.paging)
                }
                .frame(height: 220)
              
            }
            .padding(.vertical, 10)
        }
        .scrollIndicators(.hidden)
    }
}



#Preview {
    ContentView()
}
