//
//  ContentView.swift
//  A_100_SwiftUI Expandable Navigation & Search Bar - iOS 18
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
