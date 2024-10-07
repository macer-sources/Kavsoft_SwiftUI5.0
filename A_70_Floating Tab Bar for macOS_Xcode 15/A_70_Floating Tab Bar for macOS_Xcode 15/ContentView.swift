//
//  ContentView.swift
//  A_70_Floating Tab Bar for macOS_Xcode 15
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TabModel.init()
    @Environment(\.controlActiveState) private var state
    var body: some View {
        TabView(selection: $viewModel.activeTab,
                content:  {
            NavigationStack {
                Text("Tab Home View")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("", systemImage: "sidebar.left") {
                                viewModel.hideTabbar.toggle()
                            }
                        }
                    }
            }
           .tag(Tab.home)
                .background(HideTabBar())
            Text("Tab Favourites View").tag(Tab.favourites)
            Text("Tab Notifications View").tag(Tab.notifications)
            Text("Tab Settings View").tag(Tab.settings)
        })
        // TODO: appear 中添加， window可能还没有
        .customOnChange(value: state, initial: true) { newValue in
            if newValue == .key {
                viewModel.addTabBar()
            }
        }
        .opacity(viewModel.isTabBarAdded ? 1 : 0)
        .background {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .global)
                
                Color.clear
                    .customOnChange(value: rect) { _ in
                        // frame change
                        viewModel.updateTabPosition()
                    }
            }
        }
        .frame(minWidth: 100, minHeight: 200)
        .padding(.bottom, viewModel.isTabBarAdded ? 0 : 1)
    }
}

extension View {
    @ViewBuilder
    func customOnChange<Value: Equatable>(value: Value, initial:Bool = false, result: @escaping (Value) -> Void) -> some View {
        if #available(macOS 14, *) {
            self.onChange(of: value, initial: initial) { oldValue, newValue in
                result(newValue)
            }
        } else {
            self.onChange(of: value, perform: { value in
                result(value)
            })
            // onChange 修饰符不会在开始时调用，这就是选项卡栏不出现在新窗口中的原因。由于旧的 onChange 修饰符缺少初始检查选项，因此在这种情况下我们不得不使用 onAppear。但是，新的 onChange 修饰符将有一个。
            .onAppear {
                if initial {
                    result(value)
                }
            }
        }
    }
    
    @ViewBuilder
    func windowBackground() -> some View {
        if #available(macOS 14, *) {
            self.background(.windowBackground)
        }else {
            self.background(.background)
        }
    }
}


#Preview {
    ContentView()
}
class TabModel: ObservableObject {
    @Published var activeTab: Tab = .home
    @Published private(set) var isTabBarAdded: Bool = false
    @Published var hideTabbar: Bool = false
    private let id = UUID.init().uuidString
    
    func addTabBar() {
        guard !isTabBarAdded else {return}
        if let applicationWindow = NSApplication.shared.mainWindow {
            let customTabBar = NSHostingView(rootView: FloatingTabBarView.init().environmentObject(self))
            let floatingWindow = NSWindow()
            floatingWindow.styleMask = .borderless
            floatingWindow.contentView = customTabBar
            floatingWindow.backgroundColor = .clear
            floatingWindow.title = id
            
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 150) / 2 ))
            
            
            applicationWindow.addChildWindow(floatingWindow, ordered: .above)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                self?.isTabBarAdded = true
            }
        } else {
            
        }
    }
    
    func updateTabPosition() {
        guard let floatingWindow = NSApplication.shared.windows.first(where: {$0.title == id}), let applicationWindow = NSApplication.shared.mainWindow else {return}
        
        
        let windowSize = applicationWindow.frame.size
        let windowOrigin = applicationWindow.frame.origin
        
        floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 150) / 2 ))

    }
    
    
}

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case favourites = "suit.heart.fill"
    case notifications = "bell.fill"
    case settings = "gearshape"
}

fileprivate struct FloatingTabBarView: View {
    @EnvironmentObject private var viewModel: TabModel
    @Environment(\.colorScheme) private var colorScheme
    
    @Namespace private var animation
    private let animationID = UUID.init()
    var body: some View {
        VStack(spacing: 0, content: {
            ForEach(Tab.allCases, id:\.rawValue) { tab in
                Button {
                    viewModel.activeTab = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(viewModel.activeTab == tab ? (colorScheme == .dark ? .black: .white) : .primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            if viewModel.activeTab == tab {
                                Circle()
                                    .fill(.primary)
                                    .matchedGeometryEffect(id: animationID, in: animation)
                            }
                        }
                        .contentShape(.rect)
                        .animation(.bouncy, value: viewModel.activeTab)
                }
                .buttonStyle(.plain)

            }
        })
        .padding(5)
        .frame(width: 45, height: 150)
        .windowBackground()
        .clipShape(.capsule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 50) // TODO: 50 有5 个像素间距
        .contentShape(.capsule)
        .offset(x: viewModel.hideTabbar ? 60 : 0)
        .animation(.snappy, value: viewModel.hideTabbar)
    }
}


// hiding macos tabbar
fileprivate struct HideTabBar: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        return .init()
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            //
            if let tabView = nsView.superview?.superview?.superview as? NSTabView {
                tabView.tabViewType = .noTabsNoBorder
                tabView.tabViewBorderType = .none
                tabView.tabPosition = .none
                
            }
        }
    }
}
