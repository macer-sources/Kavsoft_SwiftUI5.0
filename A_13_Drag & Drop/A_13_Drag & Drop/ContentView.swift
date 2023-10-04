//
//  ContentView.swift
//  A_13_Drag & Drop
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    @State private var colors:[Color] = [
        .red,
        .blue,
        .purple,
        .yellow,
        .black,
        .indigo,
        .cyan,
        .brown,
        .mint,
        .orange
    ]
    
    @State private var draggingItem: Color?
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView(.vertical) {
                    let columns = Array(repeating: GridItem(spacing: 10), count: 3)
                    LazyVGrid(columns: columns, spacing: 10, content: {
                        ForEach(colors, id: \.self) {color in
                            GeometryReader(content: {
                                let size = $0.size
                                RoundedRectangle(cornerRadius: 10)
                                .fill(color.gradient)
                                // Drag
                                .draggable(color) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
//                                        .frame(width: size.width, height: size.height)
                                        .frame(width: 1, height: 1)
                                        .onAppear {
                                            draggingItem = color
                                        }
                                }
                                // Drop
                                .dropDestination(for: Color.self) { items, location in
                                    draggingItem = nil
                                    return false
                                } isTargeted: { status in
                                    if let draggingItem, status, draggingItem != color {
                                        guard let sourceIndex = colors.firstIndex(of: draggingItem), let destinationIndex = colors.firstIndex(of: color) else {return}
                                        // moving color from source to destination
                                        withAnimation(.bouncy) {
                                            let sourceItem = colors.remove(at: sourceIndex)
                                            colors.insert(sourceItem, at: destinationIndex)
                                        }
                                        
                                    }
                                }
                            })
                            .frame(height: 100)
                        }
                    })
                    .padding(15)
                }
                .navigationTitle("Movable Grid")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
