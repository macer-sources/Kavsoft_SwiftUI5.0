//
//  ContentView.swift
//  61_SwiftUI Animated Toasts
//
//  Created by Kan Tao on 2024/1/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Present Toast") {
                Toast.shared.present(title: "Hello World",
                                     symbol: "globe",
                                     timing: .long
                )
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
    
}
