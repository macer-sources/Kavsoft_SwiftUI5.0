//
//  ContentView.swift
//  A_SwiftUI  Image Gallery
//
//  Created by Kan Tao on 2024/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedImte: Int?
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 2),
                GridItem(.flexible(minimum: 100, maximum: 200),spacing: 2),
                GridItem(.flexible(minimum: 100, maximum: 200), spacing: 2)
            ],spacing: 2 ,content: {
                ForEach(0..<10) { data in
                    Rectangle()
                        .fill(Color.init(hue: Double.random(in: 0..<1), saturation: 1, brightness: 1))
                        .aspectRatio(1,contentMode: .fill)
                }
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
