//
//  ContentView.swift
//  SwiftUI Stacked ScrollView
//
//  Created by Kan Tao on 2024/6/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader(content: { geometry in
                Image(.wallpaper)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            })
            Home()
        }
    }
}

#Preview {
    ContentView()
}
