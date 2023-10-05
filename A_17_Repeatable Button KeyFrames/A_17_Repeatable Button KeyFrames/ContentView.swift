//
//  ContentView.swift
//  A_17_Repeatable Button KeyFrames
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            Text("My Cart")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.left")
                            .fontWeight(.bold)
                    })
                    .foregroundStyle(.black)
                }
                .padding(15)
                .background(.white)
            
            ScrollView(.vertical) {
                VStack(spacing: 12, content: {
                    HStack(spacing: 12, content: {
                        Image(.pexels1)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .padding(10)
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("iPhone 14 Pro Max")
                                .fontWeight(.semibold)
                            
                            Text("Purple- 512GB")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Text("$1399")
                                .fontWeight(.bold)
                            
                        })
                        CustomIncrementerView(count: $count)
                            .scaleEffect(0.9, anchor: .trailing)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.shadow(.drop(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)), in: .rect(cornerRadius: 20))
                    
                })
                .padding(15)
                .padding(.top, 10)
            }
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .clipShape(.rect(topLeadingRadius: 35, topTrailingRadius: 35))
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
