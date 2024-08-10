//
//  HackerTextView.swift
//  Hacker Text Effect
//
//  Created by Kan Tao on 2024/6/2.
//

import SwiftUI

struct HackerTextView: View {
    var text: String
    var trigger: Bool
    var transition: ContentTransition = .interpolate
    var duration: CGFloat = 1
    var speed: CGFloat = 0.1
    
    @State private var animatedText: String = ""
    @State private var randomCharacters:[Character] = {
        let string = "qwertyuiopasdfghjklzxcvbnm,./;'[]-=1234567890QWERTYUIOPASDFGHJKLZXCVBNM"
        return Array(string)
    }()
    
    @State private var animationID: String = UUID().uuidString
    
    var body: some View {
        Text(animatedText)
            .fontDesign(.monospaced)
            .truncationMode(.tail)
            .contentTransition(transition)
            .animation(.easeInOut(duration: 0.1),value: animatedText)
            .onAppear(perform: {
                guard animatedText.isEmpty else {return}
                setRandomCharacters()
                animateText()
            })
            .customOnChange(value: trigger) { value in
                animateText()
            }
            .customOnChange(value: text) { value in
                animatedText = text
                animationID = UUID().uuidString
                setRandomCharacters()
                animateText()
            }
    }
    
    private func animateText() {
        let currentId = animationID
        for index in text.indices {
            let delay = CGFloat.random(in: 0...duration)
            var timerDuration:CGFloat = 0
            let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                if currentId != animationID {
                    timer.invalidate()
                }else {
                    timerDuration += speed
                    if timerDuration >= delay {
                        if text.indices.contains(index) {
                            let actualCharacter = text[index]
                            replaceCharacter(at: index, character: actualCharacter)
                        }
                        
                        timer.invalidate()
                    }else {
                        guard let randomCharacter = randomCharacters.randomElement() else {return}
                        replaceCharacter(at: index, character: randomCharacter)
                    }
                }
            }
            timer.fire()
        }
    }
    
    private
    func setRandomCharacters() {
        animatedText = text
        for index in animatedText.indices {
            guard let randomCharacter = randomCharacters.randomElement() else {return}
            replaceCharacter(at: index, character: randomCharacter)
        }
    }
    
    
    // chnages character at the given index
    func replaceCharacter(at index: String.Index, character:Character) {
        guard animatedText.indices.contains(index) else {return}
        let indexCharacter = String(animatedText[index])
        
        if indexCharacter.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            animatedText.replaceSubrange(index...index, with: String(character))
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func customOnChange<T:Equatable>(value:T,result: @escaping(T) -> Void) -> some View {
        if #available(iOS 17, *) {
            self.onChange(of: value) { oldValue, newValue in
                result(newValue)
            }
        }else {
            self.onChange(of: value, perform: { value in
                result(value)
            })
        }
    }
}



#Preview {
    ContentView()
}
