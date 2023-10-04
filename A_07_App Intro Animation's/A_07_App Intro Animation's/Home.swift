//
//  Home.swift
//  A_07_App Intro Animation's
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Home: View {
    @State private var intros: [Intro] = sampleIntros
    @State private var activeIntro: Intro?
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            VStack(content: {
                if let activeIntro {
                    Rectangle()
                        .fill(activeIntro.bgColor)
                        .padding(.bottom, -30)
                        .overlay {
                            // circle and text
                            Circle()
                                .fill(activeIntro.circleColor)
                                .frame(width: 38, height: 38)
                                .background(alignment: .leading, content: {
                                    Capsule()
                                        .fill(activeIntro.bgColor)
                                        .frame(width: size.width)
                                })
                                .background(alignment: .leading) {
                                    Text(activeIntro.text)
                                        .font(.largeTitle)
                                        .foregroundStyle(activeIntro.textColor)
                                        .frame(width: textSize(activeIntro.text))
                                        .offset(x: 10)
                                        .offset(x: activeIntro.textOffset)
                                }
                            // moving circle in the opposite direction
                                .offset(x: -activeIntro.circleOffset)
                        }
                }
                // login buttons
                LoginButtons()
                    .padding(.bottom, safeArea.bottom)
                    .padding(.top, 10)
                    .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
                
            })
            .ignoresSafeArea()
        })
        .task {
            if activeIntro == nil {
                activeIntro = sampleIntros.first
                // delaying 0.15s and starting animation
                let onSecond = UInt64(1_000_000_000)
                try? await Task.sleep(nanoseconds: onSecond * UInt64(0.15))
                animate(0)
            }
        }
    }
    
    // animating introls
    func animate(_ index: Int, _ loop: Bool = true) {
        if intros.indices.contains(index + 1) {
            // updateing text and text color
            activeIntro?.text = intros[index].text
            activeIntro?.textColor = intros[index].textColor
            
            withAnimation(.snappy(duration: 1),completionCriteria: .removed) {
                activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
                activeIntro?.circleOffset = -(textSize(intros[index].text) + 20)/2
            } completion: {
                // resetting the offset whith next slide color change
                withAnimation(.snappy(duration: 0.8),completionCriteria: .logicallyComplete) {
                    activeIntro?.textOffset = 0
                    activeIntro?.circleOffset = 0
                    activeIntro?.circleColor = intros[index + 1].circleColor
                    activeIntro?.bgColor = intros[index + 1].bgColor
                } completion: {
                    // going to next slide
                    // simply recursion
                    animate(index + 1, loop)
                }

            }

        }else {
            // looping
            // if looping applied , then reset the index to 0
            if loop {
                animate(0, loop)
            }
        }
    }
    
    
    
    // fetching text size based on fonts
    func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
    
    
    
    // login buttons
    @ViewBuilder
    func LoginButtons() -> some View {
        VStack(spacing: 12, content: {
            Button(action: {}, label: {
                Label("Continue With Apple", systemImage: "applelogo")
                    .foregroundStyle(.black)
                    .fillButton(.white)
            })
            Button(action: {}, label: {
                Label("Continue With Phone", systemImage: "phone.fill")
                    .foregroundStyle(.white)
                    .fillButton(.buton)
            })
            Button(action: {}, label: {
                Label("Sign Up With Email", systemImage: "envelope.fill")
                    .foregroundStyle(.white)
                    .fillButton(.buton)
            })
            Button(action: {}, label: {
                Label("Login", systemImage: "envelope.fill")
                    .foregroundStyle(.white)
                    .fillButton(.black)
                    .shadow(color: .white, radius: 1)
            })
        })
        .padding(15)
    }
    
}

extension View {
    @ViewBuilder
    func fillButton(_ color: Color) -> some View {
        self.fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}




#Preview {
    ContentView()
}
