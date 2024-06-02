//
//  ContentView.swift
//  SwiftUI TabView Offset Reader
//
//  Created by Kan Tao on 2024/5/29.
//

import SwiftUI



enum DummyTab: String, CaseIterable {
    case home = "Home"
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .chats:
            return .blue
        case .calls:
            return .black
        case .settings:
            return .purple
        }
    }
}



struct ContentView: View {
    
    @State private var activeTab:DummyTab = .home
    
    var offsetObserver = PageOffsetObserver()
    
    var body: some View {
        VStack(spacing: 15, content: {
            
            TabBar(.gray)
                .overlay(content: {
                    if let collectionViewBounds = offsetObserver.collectionView?.bounds {
                        // TODO: 这里用于滚动时渐变的效果
                        GeometryReader(content: { geometry in
                            let width = geometry.size.width
                            let tabCount = CGFloat(DummyTab.allCases.count)
                            let capsuleWidth = width / tabCount
                            let progress = offsetObserver.offset / collectionViewBounds.width
                            
                            Capsule()
                                .fill(.black)
                                .frame(width: capsuleWidth)
                                .offset(x: progress * capsuleWidth)
                            
                            TabBar(.white, .semibold)
                                .mask(alignment: .leading) {
                                    Capsule()
                                        .frame(width: capsuleWidth)
                                        .offset(x: progress * capsuleWidth)
                                }
                        })
                    }
                })
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                .padding([.horizontal, .top], 15)
            
            
            TabView(selection: $activeTab,
                    content:  {
                DummyTab.home.color.tag(DummyTab.home)
                    .background {
                        if !offsetObserver.isObserving {
                            FindCollectionView { collectionView in
                                offsetObserver.collectionView = collectionView
                                offsetObserver.observe()
                            }
                        }
           
                    }
                DummyTab.chats.color.tag(DummyTab.chats)
                DummyTab.calls.color.tag(DummyTab.calls)
                DummyTab.settings.color.tag(DummyTab.settings)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
        })
        .overlay {
            Text("\(offsetObserver.offset)")
        }
    }
    
    
    @ViewBuilder
    private func TabBar(_ tint: Color, _ weigth: Font.Weight = .regular) -> some View {
        HStack(spacing: 0, content: {
            ForEach(DummyTab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(weigth)
                    .padding(.vertical, 10)
                    .foregroundStyle(tint)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                            activeTab = tab
                        }
                    }
            }
        })
    }
    
    
    
}

#Preview {
    ContentView()
}





@Observable
class PageOffsetObserver: NSObject {
    var collectionView: UICollectionView?
    var offset: CGFloat = 0
    
    private(set) var isObserving: Bool = false
    
    deinit {
        remove()
    }
    
    func observe() {
        guard !isObserving else {return}
        collectionView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        isObserving = true
    }
    
    func remove() {
        isObserving = false
        collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        debugPrint("\(String(describing: keyPath))")
        guard keyPath == "contentOffset" else {return}
        if let contentOffset = (object as? UICollectionView)?.contentOffset {
            offset = contentOffset.x
        }
    }
}

struct FindCollectionView: UIViewRepresentable {
    var result:(UICollectionView) -> Void
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let collectionView = view.collectionSuperView {
                result(collectionView)
            }
        }
        
        return view
    }
}


extension UIView {
    // finding the collectionView by traversing the superview
    var collectionSuperView: UICollectionView? {
        if let collectionView = superview as? UICollectionView {
            return collectionView
        }
        return superview?.collectionSuperView
    }
}
