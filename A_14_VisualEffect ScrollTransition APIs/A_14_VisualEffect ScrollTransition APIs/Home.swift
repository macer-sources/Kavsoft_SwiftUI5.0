//
//  Home.swift
//  A_14_VisualEffect ScrollTransition APIs
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Home: View {
    @State private var pickerType: TripPicker = .normal
    
    
    var body: some View {
        VStack {
            Picker("", selection: $pickerType) {
                ForEach(TripPicker.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            GeometryReader(content: { geometry in
                let padding = (geometry.size.width - 70 ) / 2
                // Circular Silder
                ScrollView(.horizontal) {
                    HStack(spacing: 35, content: {
                        ForEach(1...6, id:\.self) {index in
                            Image("image\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
                        }
                    })
                    .scrollTargetLayout()
                }
                .safeAreaPadding(.horizontal, padding)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .frame(height: geometry.size.height)
                
            })
            .frame(height: 70)
        }
    }
    
    
    // Circluar slider view offset
    
    
}

#Preview {
    ContentView()
}

enum TripPicker: String, CaseIterable {
    case scaled = "Scaled"
    case normal = "Normal"
}

