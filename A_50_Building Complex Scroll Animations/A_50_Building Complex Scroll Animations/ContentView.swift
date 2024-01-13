//
//  ContentView.swift
//  A_50_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let safeArea = geometry.safeAreaInsets
            Home(safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .top)
        })
    }
}

#Preview {
    ContentView()
}
