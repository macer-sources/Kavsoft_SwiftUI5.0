//
//  ContentView.swift
//  33_Animated Tab Icons SF Symbols
//
//  Created by Kan Tao on 2024/1/2.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: Tab = .photos
    @State private var allTabs:[AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    var body: some View {
        VStack {
            TabView(selection: $activeTab,
                    content:  {
                Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
                Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
            })
            
            CustomTabbar()
        }
    }
    
    // Custom Tab Bar
    @ViewBuilder
    func CustomTabbar() -> some View {
        HStack(spacing: 0, content: {
            ForEach($allTabs) { $animationTab in
                let tab = animationTab.tab
                VStack(spacing: 4, content: {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                    // SF 5 允许动画实现
                        .symbolEffect(.bounce.down.byLayer, value: animationTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                })
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy,completionCriteria: .logicallyComplete) {
                        activeTab = tab
                        animationTab.isAnimating = true
                    } completion: {
//                        animationTab.isAnimating =  nil
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animationTab.isAnimating =  nil
                        }
                    }

                }
            }
        })
        .background(.bar)
    }
    
    
}

#Preview {
    ContentView()
}
