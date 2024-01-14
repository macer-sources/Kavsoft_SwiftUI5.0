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
            LazyVStack(content: {
                ForEach(colors, id: \.self) { color in
                    SwipeAction(cornerRadius: 15, direction: .trailing) {
                        SimpleCardView(color)
                    } actions: {
                        Action.init(tint: .blue, icon: "star") {
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
    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0, content: {
                    content
                    // to take full available space
                        .containerRelativeFrame(.horizontal)
                        .background {
                            if let firstAction = actions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            proxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
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
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        })
        .allowsHitTesting(isEnabled)
    }
    
    private func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
    
    // action button
    @ViewBuilder
    private func ActionButtons(resetPosition:@escaping () -> Void) -> some View {
        // each button will have 100 width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0, content: {
                    ForEach(actions) { button in
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
                    }
                })
            }
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
