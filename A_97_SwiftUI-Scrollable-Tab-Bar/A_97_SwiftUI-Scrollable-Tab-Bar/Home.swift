//
//  Home.swift
//  A_97_SwiftUI-Scrollable-Tab-Bar
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct Home: View {
    @State private var tabs:[TabModel] = [
        .init(id: Tab.research),
        .init(id: Tab.deployment),
        .init(id: Tab.analytics),
        .init(id: Tab.audience),
        .init(id: Tab.privacy),
    ]
    @State private var activeTab:Tab =  .research
    @State private var tabBarScrollState: Tab?
    @State private var mainViewScrollState: Tab?
    @State private var progress:CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            CustomTabBar()
            MainView()
        }
    }
}

// header view
extension Home {
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.yellow)
                .frame(width: 100, height: 50)
            Spacer()
            
            Button("", systemImage: "plus.circle", action: {})
                .font(.title2)
                .tint(.primary)
            Button("", systemImage: "bell", action: {})
                .font(.title2)
                .tint(.primary)
            
            // profile
            Button(action: {}, label: {
                Circle()
                    .fill(.red)
                    .frame(width: 30, height: 30)
            })
        }
        .padding(15)
        // divider
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
}

// dynamic scrolllable tab bar
extension Home {
    @ViewBuilder
    private func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20, content: {
                ForEach($tabs) { $tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    }, label: {
                        Text(tab.id.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ?  Color.primary : .gray)
                            .contentShape(.rect)
                    })
                    .buttonStyle(.plain)
                    .rect { rect in
                        //// 即使将其放置在滚动视图之外，指示器也会随滚动视图滚动，因为选项卡按钮上的 minX 值是实时更新的，因此插值会实时映射其值，从而导致指示器在滚动时沿滚动视图移动。
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            })
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .scrollIndicators(.hidden)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                let inputRange = tabs.indices.compactMap({return CGFloat($0)})
                let outRange = tabs.compactMap({ return $0.size.width})
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outRange: outRange)
                
                let outputPositionRange = tabs.compactMap({$0.minX})
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outRange: outputPositionRange)
                
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth,height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
    }
}

extension Home {
    @ViewBuilder
    private func MainView() -> some View {
        GeometryReader(content: { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0, content: {
                    ForEach(tabs) { tab in
                        Text(tab.id.rawValue)
                            .frame(width: size.width, height: size.height)
                            .contentShape(.rect)
                    }
                })
                .scrollTargetLayout()
                .rect { rect in
                    progress = -rect.minX / size.width
                    
                }
            }
            .scrollPosition(id: $mainViewScrollState)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onChange(of: mainViewScrollState) { oldValue, newValue in
                if let newValue {
                    withAnimation(.snappy) {
                        tabBarScrollState = newValue
                        activeTab = newValue
                    }
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
