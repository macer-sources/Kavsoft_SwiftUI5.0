//
//  Home.swift
//  A_48_Building Scrollable Tab View
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct Home: View {
    @State private var selectedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    
    // tab progress
    @State private var tabProgress: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 15, content: {
            HStack(content: {
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "bell.badge")
                })
            })
            .font(.title2)
            .overlay {
                Text("Message")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            // Custom Tab Bar
            CustomTabBar()
            
            // paging view using new ios 17 APIS
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0, content: {
                        SampleView(.purple)
                            .id(Tab.chats)
                            .containerRelativeFrame(.horizontal)
                        SampleView(.red)
                            .id(Tab.calls)
                            .containerRelativeFrame(.horizontal)
                        SampleView(.blue)
                            .id(Tab.settings)
                            .containerRelativeFrame(.horizontal)
                    })
                    .scrollTargetLayout()
                    // TODO: 根据偏移量，决定选中那个tab 的
                    .offsetX { value in
                        // converting offset into progress
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        // capping progress BTW 0-1
                        tabProgress = max(min(progress, 1), 0 )
                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            })
            
        })
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity,  alignment: .top)
        .background(.gray.opacity(0.1))
    }
}

extension Home {
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0, content: {
            ForEach(Tab.allCases, id:\.rawValue) { tab in
                HStack(spacing: 10, content: {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.rect)
                .onTapGesture {
                    // updateing tab
                    withAnimation(.smooth) {
                        selectedTab = tab
                    }
                }
            }
        })
        .tabMask(tabProgress)
        // scollable active tab indicator
        // TODO: 根据偏移量，实现 类似 animat 的效果
        .background {
            GeometryReader(content: { geometry in
                let size = geometry.size
                let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x: tabProgress * (size.width - capusleWidth))
            })
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
}

extension Home {
    // sample view for demonstrating scrollable tab bar idicator
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array.init(repeating: GridItem(), count: 2), content: {
                ForEach(1...10, id:\.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading, content: {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6, content: {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                })
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            })
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
}

#Preview {
    Home()
}
