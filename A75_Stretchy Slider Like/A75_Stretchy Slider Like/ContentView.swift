//
//  ContentView.swift
//  A75_Stretchy Slider Like
//
//  Created by Kan Tao on 2024/2/8.
//

import SwiftUI

struct ContentView: View {
    @State private var progress:CGFloat = .zero
    @State private var axis: CustomSlider.SliderAxis = .vertical
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $axis) {
                    Text("Vertical")
                        .tag(CustomSlider.SliderAxis.vertical)
                    Text("Horizontal")
                        .tag(CustomSlider.SliderAxis.horizontal)
                } label: {
                    
                }
                .pickerStyle(.segmented)

                
                
                CustomSlider(sliderProgress: $progress, symbol: .init(icon: "airpodspro", tint: .gray, font: .system(size: 25), padding: 20, display: axis == .vertical, alignment: .bottom), axis: axis, tint: .white)
                    .frame(width: axis == .horizontal ? 220 : 60, height: axis == .horizontal ? 30 : 180)
                    .frame(maxHeight: .infinity)
                    .animation(.snappy,value: axis)
            }
            .padding()
            .background(.gray.opacity(0.2))
            .frame(maxWidth: .infinity, alignment: .bottom)
            .navigationTitle("Stretchy Slider")
        }
    }
}

#Preview {
    ContentView()
}
