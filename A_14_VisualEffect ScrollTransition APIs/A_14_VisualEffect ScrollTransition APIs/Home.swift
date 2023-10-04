//
//  Home.swift
//  A_14_VisualEffect ScrollTransition APIs
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Home: View {
    @State private var pickerType: TripPicker = .normal
    @State private var activeId: Int?
    
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
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(y: offset(geometryProxy))
                                        .offset(y: scale(geometryProxy) * 15)
                                }
                                .scrollTransition(.interactive,axis: .horizontal) { view, phase in
//                                    view.offset(y: phase.isIdentity && activeId == index ? 15 : 0)
                                    view.scaleEffect(phase.isIdentity && activeId == index && pickerType == .scaled ?  1.5 : 1, anchor: .bottom)
                                }
                        }
                    })
                    .frame(height: geometry.size.height)
                    .offset(y: -30)
                    .scrollTargetLayout()
                }
                .background {
                    if pickerType == .normal {
                        Circle()
                            .fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
                            .frame(width: 85, height: 85)
                            .offset(y: -15)
                    }
                }
                .safeAreaPadding(.horizontal, padding)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeId)
                .frame(height: geometry.size.height)
                
            })
            .frame(height: 200)
//            .background(.red)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    
    // Circluar slider view offset
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let progress = progress(proxy)
        // simply moving view up/down base on progress
        return progress < 0 ? progress * -30 : progress * 30
    }
    
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let progress = min(max(progress(proxy), -1), 1)
        return progress < 0 ? 1 + progress :  1 - progress
    }
    
    
    func progress(_ proxy: GeometryProxy) -> CGFloat {
        let viewWidth = proxy.size.width
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        return minX /  viewWidth
    }
    
}

#Preview {
    ContentView()
}

enum TripPicker: String, CaseIterable {
    case scaled = "Scaled"
    case normal = "Normal"
}

