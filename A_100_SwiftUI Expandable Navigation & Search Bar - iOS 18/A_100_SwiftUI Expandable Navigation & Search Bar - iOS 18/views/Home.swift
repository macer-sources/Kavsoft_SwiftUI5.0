//
//  Home.swift
//  A_100_SwiftUI Expandable Navigation & Search Bar - iOS 18
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct Home: View {
    @State private var search = ""
    @State private var activeTab:Tab = .all
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isSearching: Bool
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15,content: {
                DummayMessageView()
            })
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigagionBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching) // 给 xmark 添加动画效果
        }
        .scrollTargetBehavior(CustomScrollTargetBehoviour())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 190, for: .scrollIndicators) // 调整 scroll bar 的位置
    }
}


extension Home {
    @ViewBuilder
    private func ExpandableNavigagionBar(_ title: String = "Message") -> some View {
        GeometryReader(content: { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollviewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + max(min(minY / scrollviewHeight, 1), 0) * 0.5 : 1
            // 70: 它只是一个随机值，您可以更改它以满足您的需要。请记住，值越低，滚动动画的速度就越快，反之亦然。
            let progress = isSearching ? 1 :  max(min(-minY / 70, 1), 0)
            
            VStack(spacing: 10, content: {
                // title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                // search bar
                HStack(spacing: 12, content: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    TextField("Search Conversation", text: $search)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        })
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                })
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15)) // 横向扩展，内容扩宽
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25.0 - (progress * 25)) // 圆角处理
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190) // 顶部扩展
                        .padding(.bottom, -progress * 65) // 底部扩展，包含 tab
                        .padding(.horizontal, -progress * 15) // 横向扩展 ，全屏
                }
                // custom segment picker
                ScrollView(.horizontal) {
                    HStack(spacing: 12, content: {
                        ForEach(Tab.allCases, id:\.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }, label: {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (colorScheme == .dark ? .black :  .white) : Color.primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            })
                            .buttonStyle(.plain)
                        }
                    })
                }
                .frame(height: 50)
            })
            .padding(.top,25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65) // offset 覆盖 title
        })
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
}

extension Home {
    @ViewBuilder
    private func DummayMessageView() -> some View {
        ForEach(1...20, id: \.self) { count in
            HStack {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 6, content: {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    Rectangle()
                        .frame(height: 8)
                    Rectangle()
                        .frame(width: 80, height: 8)
                })
            }
            .foregroundStyle(.gray.opacity(0.25))
            .padding(.horizontal, 15)
        }
    }
}

// 如果用户在滚动过渡过程中停止滚动，则视图可能会显得不均匀。在某些情况下，我们可以使用新的 Scroll 目标 Behaviour 来检测拖动何时完成，从而允许我们将过渡重置为其开始阶段或根据结束目标值完成过渡。
struct CustomScrollTargetBehoviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}



#Preview {
    ContentView()
}
