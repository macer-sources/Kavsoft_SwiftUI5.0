//
//  ContentView.swift
//  A_12_Carousel Slider Inspired From Material Carousel
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Carousel")
        }
    }
}

#Preview {
    ContentView()
}
