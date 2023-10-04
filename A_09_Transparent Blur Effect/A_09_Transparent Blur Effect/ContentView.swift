//
//  ContentView.swift
//  A_09_Transparent Blur Effect
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    @State private var activePic: String = "image1"
    @State private var blurType: BlurType = .freeStyle
    
    var body: some View {
        GeometryReader.init(content: { geometry in
            let safeArea = geometry.safeAreaInsets
            ScrollView(.vertical) {
                VStack(spacing: 15, content: {
                    TransparentBlurView(removeAllFilters: false)
                        .blur(radius: 15, opaque: blurType == .clipped)
                        .padding([.horizontal, .top], -30)
                        .frame(height: 100 + safeArea.top)
                        .visualEffect { content, geometryProxy in
                            content.offset(y: (geometryProxy.bounds(of: .scrollView)?.minY ?? 0))
                        }
                        .zIndex(1000)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        GeometryReader(content: { geometry in
                            let size = geometry.size
                            Image(activePic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(cornerRadius: 25))
                        })
                        .frame(height: 500)
                        Text("Blur Type")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 15)
                        
                        Picker("", selection: $blurType) {
                            ForEach(BlurType.allCases, id:\.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    })
                    .padding(15)
                    .padding(.bottom, 500)
                })
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(.container, edges: .top)
        })
    }
}

#Preview {
    ContentView()
}


enum BlurType: String, CaseIterable {
    case clipped = "Clipped"
    case freeStyle = "Free Style"
}


struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters:Bool = false
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let layer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    layer.filters = []
                }else {
                    layer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}
