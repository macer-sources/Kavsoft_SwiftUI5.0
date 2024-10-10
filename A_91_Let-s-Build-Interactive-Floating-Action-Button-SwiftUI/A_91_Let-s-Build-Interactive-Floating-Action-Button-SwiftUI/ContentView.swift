//
//  ContentView.swift
//  A_91_Let-s-Build-Interactive-Floating-Action-Button-SwiftUI
//
//  Created by Kan Tao on 2024/10/10.
//

import SwiftUI

struct ContentView: View {
    @State private var colors:[Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .cyan,
        .brown,
        .purple,
        .indigo,
        .mint,
        .pink
    ]
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, content: {
                    ForEach(colors, id: \.self) { count in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(count.gradient)
                            .frame(height: 200)
                    }
                })
                .padding(15)
            }
            .navigationTitle("Floating Button")
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingButton {
                FloatingAction(symbol: "tray.full.fill") {
                    debugPrint("1")
                }
                FloatingAction(symbol: "lasso.badge.sparkles") {
                    debugPrint("2")
                }
                FloatingAction(symbol: "square.and.arrow.up.fill") {
                    debugPrint("3")
                }
            } label: {isExpanded in
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .scaleEffect(1.02)
                    .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black, in: .circle)
                    // scale effect when expanded
                    .scaleEffect(isExpanded ? 0.9 : 1)
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
