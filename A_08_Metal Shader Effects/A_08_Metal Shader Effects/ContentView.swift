//
//  ContentView.swift
//  A_08_Metal Shader Effects
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    PixellateView()
                        .navigationTitle("Pixellate")
                } label: {
                    Text("Pixellate")
                }
                
                NavigationLink {
                    WavesView()
                        .navigationTitle("Waves")
                } label: {
                    Text("Waves")
                }
            }
        }
        .navigationTitle("Shaders Example")
    }
}


extension ContentView {
    @ViewBuilder
    func PixellateView() -> some View {
        VStack(content: {
            Text("Placeholder")
        })
    }
    
    @ViewBuilder
    func WavesView() -> some View {
        VStack(content: {
            Text("Placeholder")
        })
    }
}



#Preview {
    ContentView()
}
