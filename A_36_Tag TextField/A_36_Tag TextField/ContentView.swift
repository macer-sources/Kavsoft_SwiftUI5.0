//
//  ContentView.swift
//  A_36_Tag TextField
//
//  Created by Kan Tao on 2024/1/2.
//

import SwiftUI

struct ContentView: View {
    @State private var tags:[Tag] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    TagTextField(tags: $tags)
                }
                .padding()
            }
            .navigationTitle("TagField")
        }
    }
}

#Preview {
    ContentView()
}
