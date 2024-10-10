//
//  FloatingButton.swift
//  A_91_Let-s-Build-Interactive-Floating-Action-Button-SwiftUI
//
//  Created by Kan Tao on 2024/10/10.
//

import SwiftUI

struct FloatingButton<Label: View>: View {
    var buttomSize: CGFloat
    var actions:[FloatingAction]
    var label:(Bool) -> Label
    init(buttomSize: CGFloat = 50, @FloatingActionBuilder actions: @escaping () -> [FloatingAction], @ViewBuilder label: @escaping (Bool) -> Label) {
        self.buttomSize = buttomSize
        self.actions = actions()
        self.label = label
    }
    
    @State private var isExpanded: Bool = false
    @GestureState private var isDragging: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectionAction: FloatingAction?
    var body: some View {
        Button(action: {
            isExpanded.toggle()
        }, label: {
            label(isExpanded)
                .frame(width: buttomSize, height: buttomSize)
                .contentShape(.rect)
        })
        .buttonStyle(NoAnimationButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded({ _ in
                    isExpanded = true
                }).sequenced(before: DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    guard isExpanded else {return}
                    dragLocation = value.location
                }).onEnded({ _ in
                    debugPrint("[DEBUG]: onEnded")
                    Task {
                        if let action = selectionAction?.action {
                            isExpanded = false
                            action()
                        }
                        selectionAction = nil
                        dragLocation = .zero
                    }
                }))
        )
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
            .frame(width: buttomSize, height: buttomSize)
        }
        .coordinateSpace(.named("FLOATING_BUTTON"))
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded)
    }
    
    
    @ViewBuilder
    private func ActionView(_ action: FloatingAction) -> some View {
        Button {
            action.action()
            isExpanded = false
        } label: {
            Image(systemName: action.symbol)
                .font(action.font)
                .foregroundStyle(action.tint)
                .frame(width: buttomSize, height: buttomSize)
                .background(action.background , in: .circle)
                .contentShape(.rect)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isExpanded)
        .animation(.snappy(duration: 0.3, extraBounce: 0)) { content in
                content
                .scaleEffect(selectionAction?.id == action.id ? 1.15 : 1)
        }
        .background {
            GeometryReader {
                let rect = $0.frame(in: .named("FLOATING_BUTTON"))
                
                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpanded && isDragging {
                            //checking if the drag localtion is inside any action's rect
                            if rect.contains(newValue) {
                                // user is pressing on this
                                selectionAction = action
                            } else {
                                // checking if it's gone out of the rect
                                if selectionAction?.id == action.id && !rect.contains(newValue) {
                                    selectionAction = nil
                                }
                            }
                        }
                    }
            }
        }
        .rotationEffect(.init(degrees: progress(action) * -90))
        .offset(x: isExpanded ? -offset/2 : 0)
        .rotationEffect(.init(degrees: progress(action) * 90))
    }
    
    //
    private var offset: CGFloat {
        let buttomSize = buttomSize + 10
        return Double(actions.count) * (actions.count == 1 ? buttomSize * 2 : (actions.count == 2 ? buttomSize * 1.25 : buttomSize))
    }
    private func progress(_ action:FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: {$0.id == action.id}) ?? 0)
        return actions.count == 1 ? 1 :  index / CGFloat(actions.count - 1)
    }
}

// custom button styles
fileprivate struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

fileprivate struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: configuration.isPressed)
    }
}



struct FloatingAction: Identifiable {
    private(set) var id: UUID = UUID()
    var symbol: String
    var font: Font = .title3
    var tint: Color = .white
    var background: Color = .black
    var action:() -> Void
}


// swiftui view lke builder to get array of actions using resultbuilder
@resultBuilder
struct FloatingActionBuilder {
    static func buildBlock(_ components: FloatingAction...) -> [FloatingAction] {
        components.compactMap({ $0 })
    }
}
