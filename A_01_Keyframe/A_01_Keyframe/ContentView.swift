//
//  ContentView.swift
//  A_01_Keyframe
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    @State private var startKeyframeAnimation = false
    var body: some View {
        VStack {
            Spacer()
            Image(.xcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .keyframeAnimator(initialValue: Keyframe(), trigger: startKeyframeAnimation) { view, frame in
                    
                    view.scaleEffect(frame.scale)
                        .rotationEffect(frame.rotation, anchor: .bottom)
                        .offset(y: frame.offsetY)
                    // Reflection
                        .background {
                            view
                                .blur(radius: 3.0)
                                .rotation3DEffect(
                                .init(degrees: 180),
                                axis: (x: 1.0, y: 0.0, z: 0.0)
                            )
                                .mask {
                                    LinearGradient(colors: [.white.opacity(frame.reflectionOpacity),
                                                            .white.opacity(frame.reflectionOpacity - 0.3),
                                                            .white.opacity(frame.reflectionOpacity - 0.45),
                                                            .clear], startPoint: .top, endPoint: .bottom)
                                }
                                .offset(y: 195)
                        }
                    
                } keyframes: { frame in
                    KeyframeTrack(\.offsetY) {
                        CubicKeyframe(10, duration: 0.15)
                        SpringKeyframe(-100, duration: 0.3, spring: .bouncy)
                        CubicKeyframe(-100, duration: 0.1)
                        CubicKeyframe(-100, duration: 0.1)
                        CubicKeyframe(-100, duration: 0.1)
                        CubicKeyframe(-100, duration: 0.15)
                        SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                    }
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(0.9, duration: 0.15)
                        CubicKeyframe(1.2, duration: 0.3)
                        CubicKeyframe(1.2, duration: 0.1)
                        CubicKeyframe(1.2, duration: 0.1)
                        CubicKeyframe(1.2, duration: 0.1)
                        CubicKeyframe(1, duration: 0.3)
                    }
                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(.zero, duration: 0.15)
                        CubicKeyframe(.zero, duration: 0.3)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 20), duration: 0.1)
                        CubicKeyframe(.init(degrees: -20), duration: 0.1)
                        CubicKeyframe(.init(degrees: 0), duration: 0.15)
                    }
                    KeyframeTrack(\.reflectionOpacity) {
                        CubicKeyframe(0.5, duration: 0.15)
                        CubicKeyframe(0.3, duration: 0.75)
                        CubicKeyframe(0.5, duration: 0.3)
                    }
                }

            Spacer()
            
            Button("Keyframe Animation") {
                startKeyframeAnimation.toggle()
            }
            .fontWeight(.bold)
        }
        .padding()
    }
}

struct Keyframe {
    var scale: CGFloat = 1
    var rotation: Angle = .zero
    var offsetY: CGFloat = 0
    var reflectionOpacity:CGFloat = 0
}



#Preview {
    ContentView()
}
