//
//  Home.swift
//  A_51_Swipe Actions For ScrollView
//
//  Created by Kan Tao on 2024/1/14.
//

import SwiftUI

struct Home: View {
    
    @State private var colors:[Color] = [.black, .yellow, .purple, .brown]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10,content: {
                ForEach(colors, id: \.self) { color in
                    SwipeAction(cornerRadius: 15, direction: .trailing) {
                        SimpleCardView(color)
                    } actions: {
                        Action.init(tint: .blue, icon: "star", isEnabled: color == .black) {
                            print("star")
                        }
                        Action.init(tint: .red, icon: "trash.fill") {
                            print("delete")
                            withAnimation(.easeInOut) {
                                colors.removeAll(where: {$0 == color})
                            }
                        }
                    }

                }
            })
            .padding(.vertical, 15)
        }
        .scrollIndicators(.hidden)
    }
}

extension Home {
    @ViewBuilder
    private func SimpleCardView(_ color: Color) -> some View {
        HStack(spacing: 12, content: {
            Circle()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 6, content: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 5)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 40, height: 5)
            })
            
            Spacer()
        })
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
//        .background(color.gradient, in: .rect(cornerRadius: 15))
    }
}


// custom card view
struct SwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @ActionBuilder var actions:[Action]
    // view propretis
    // view unique ID
    private let viewID = UUID()
    
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0, content: {
                    content
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                    // to take full available space
                        .containerRelativeFrame(.horizontal)
                        .background(scheme == .dark ? .black: .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            proxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                })
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
        })
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    private func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minX > 0 ? -minX : 0)
    }
    
    var filteredActions:[Action]  {
        return actions.filter({$0.isEnabled})
    }
    
    // action button
    @ViewBuilder
    private func ActionButtons(resetPosition:@escaping () -> Void) -> some View {
        // each button will have 100 width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0, content: {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
                    }
                })
            }
    }
    
}

// custom transition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content.mask {
            GeometryReader(content: { geometry in
                let size = geometry.size
                Rectangle()
                    .offset(y: phase == .identity ? 0 : -size.height)
            })
            .containerRelativeFrame(.horizontal)
        }
    }
}

// offset key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}


// swipe direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

// Action Model
struct Action: Identifiable {
    private(set) var id = UUID()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action:() -> Void
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}



#Preview {
    ContentView()
}
