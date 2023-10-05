//
//  CustomIncrementerView.swift
//  A_17_Repeatable Button KeyFrames
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

struct CustomIncrementerView: View {
    @Binding var count:Int
    @State private var buttonFrames:[ButtonFrame] = []
    
    var body: some View {
        HStack(spacing: 12, content: {
            Button(action: {
                if count != 0 {
                    let frame = ButtonFrame.init(value: count)
                    buttonFrames.append(frame)
                    toggleAnimation(frame.id)
                }
            }, label: {
                Image(systemName: "minus")
            })
            .buttonRepeatBehavior(.enabled)
            .fontWeight(.bold)
            
            Text("\(count)")
                .fontWeight(.bold)
                .frame(width: 45, height: 45)
                .background(.white.shadow(.drop(color: .black.opacity(0.15), radius: 5)), in: .rect(cornerRadius: 10))
                .overlay {
                    ForEach(buttonFrames) {btFrame in
                        KeyframeAnimator(initialValue: ButtonFrame.init(value: 0), trigger: btFrame.triggerKeyFrame) { frame in
                            Text("\(btFrame.value)")
                                .fontWeight(.bold)
                            // adding black background for more visible blur effect
                                .background(.black.opacity(0.4 - frame.opacity))
                                .offset(frame.offset)
                                .opacity(frame.opacity)
                            // adding blur for nice look
                                .blur(radius: (1 - frame.opacity) * 10)
                        } keyframes: { _ in
                            // defining keyframes
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(CGSize.init(width: 0, height: -20), duration: 0.2)
                                LinearKeyframe(CGSize.init(width: .random(in: -2...2), height: -40), duration: 0.2)
                                LinearKeyframe(CGSize.init(width: .random(in: -2...2), height: -90), duration: 0.4)
                            }
                            
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(0.7, duration: 0.2)
                                LinearKeyframe(0, duration: 0.2)
                            }
                        }

                    }
                }
            
            Button(action: {
                let frame = ButtonFrame(value: count)
                buttonFrames.append(frame)
                toggleAnimation(frame.id, increment: true)
            }, label: {
                Image(systemName: "plus")
            })
            .buttonRepeatBehavior(.enabled)
            .fontWeight(.bold)
        })
    }
}

struct ButtonFrame: Identifiable, Equatable {
    var id = UUID.init()
    var value: Int
    var offset: CGSize = .zero
    var opacity: CGFloat = 1
    var triggerKeyFrame: Bool = false
}


extension CustomIncrementerView {
    
    func toggleAnimation(_ id: UUID, increment: Bool = false) {
        // TODO: 这里必须要这个asyncAfter ，不然没有动画效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let index = buttonFrames.firstIndex(where: {$0.id == id}) {
                // triggering keyframe animation
                buttonFrames[index].triggerKeyFrame = true
                if increment {
                    count += 1
                }else {
                    count -= 1
                }
                
                removeFrame(id)
            }
        }
    }
    
    func removeFrame(_ id: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            buttonFrames.removeAll(where: {$0.id == id})
        }
    }
    
}
