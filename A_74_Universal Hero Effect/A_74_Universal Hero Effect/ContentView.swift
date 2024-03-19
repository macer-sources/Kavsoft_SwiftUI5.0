//
//  ContentView.swift
//  A_74_Universal Hero Effect
//
//  Created by Kan Tao on 2024/2/8.
//

import SwiftUI

struct ContentView: View {
    @State private var showView: Bool = false
    var body: some View {
        NavigationStack(root: {
            VStack {
                SourceView(id: "View 1") {
                    Circle()
                        .fill(.red)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            showView.toggle()
                        }
                }
            }
            .padding()
            .navigationTitle("Hero")
            .navigationDestination(isPresented: $showView) {
                DestinationView(id: "View 1") {
                    Circle()
                        .fill(.red)
                        .frame(width: 150, height: 150)
                        .onTapGesture {
                            showView.toggle()
                        }
                        .padding(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .navigationBarBackButtonHidden()
                        .navigationTitle("Detail View")
                }
            }
        })
        .heroLayer(id: "View 1", animate: $showView) {
            Circle()
                .fill(.red)
        } completion: { status in
            
        }

    }
}

#Preview {
    ContentView()
}
