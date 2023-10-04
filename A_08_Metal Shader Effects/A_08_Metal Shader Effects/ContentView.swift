//
//  ContentView.swift
//  A_08_Metal Shader Effects
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    
    @State private var pixellate: CGFloat = 1
    
    @State private var speed: CGFloat = 1
    @State private var amplitude: CGFloat = 5
    @State private var frequency: CGFloat = 15
    
    let startDate = Date()
    
    @State private var enableLayerEffect: Bool = false
    
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
                
                
                NavigationLink {
                    GrayscaleView()
                        .navigationTitle("Grayscale")
                } label: {
                    Text("Grayscale")
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
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 200)
                .distortionEffect(.init(function: .init(library: .default, name: "pixellate"), arguments: [.float(pixellate)]), maxSampleOffset: .zero)
            
            Slider(value: $pixellate, in: 1...20)
            
            Spacer()
        })
        .padding()
    }
    
    @ViewBuilder
    func WavesView() -> some View {
        List(content: {

            Content(false)
            
            Section("Speed") {
                Slider(value: $speed, in: 1...15)
            }
            Section("Frequency") {
                Slider(value: $frequency, in: 1...50)
            }
            Section("Amplitude") {
                Slider(value: $amplitude, in: 1...35)
            }
        })
        .padding()
    }
    
    
    @ViewBuilder
    func GrayscaleView() -> some View {
        VStack(content: {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 200)
                .layerEffect(.init(function: .init(library: .default, name: "grayscale"), arguments: []), maxSampleOffset: .zero, isEnabled: enableLayerEffect)
            
            Toggle("Enable Grayscale Layer Effect", isOn: $enableLayerEffect)
            
            Spacer()
        })
        .padding()
    }
    
    
    
    
    @ViewBuilder
    private func Content(_ image: Bool = true) -> some View {
        if image {
            TimelineView(.animation) {context in
                let time = context.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 200)
                    .frame(maxWidth: .infinity)
                    .distortionEffect(.init(function: .init(library: .default, name: "wave"), arguments: [
                        .float(time),
                        .float(speed),
                        .float(frequency),
                        .float(amplitude)
                    ]), maxSampleOffset: .zero)
            }
        }else {
            TimelineView(.animation) {context in
                let time = context.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                    Text("Hello iJustine")
                    .font(.largeTitle.bold())
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .distortionEffect(.init(function: .init(library: .default, name: "wave"), arguments: [
                        .float(time),
                        .float(speed),
                        .float(frequency),
                        .float(amplitude)
                    ]), maxSampleOffset: .init(width: .zero, height: 100))
            }
        }
    }
    
}






#Preview {
    ContentView()
}
