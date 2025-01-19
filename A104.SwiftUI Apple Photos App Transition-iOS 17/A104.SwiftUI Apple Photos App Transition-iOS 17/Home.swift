//
//  Home.swift
//  A104.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/6.
//

import SwiftUI

struct Home: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Text("Recents")
                        .font(.largeTitle.bold())
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3) {
                        ForEach($bindableCoordinator.items) { $item in
                            GirdImageView(item)
                                .id(item.id)
                                .didFrameChange(result: { frame, bounds in
                                    let minY = frame.minY
                                    let maxY = frame.maxY
                                    let height = bounds.height
                                    
                                    if maxY < 0 || minY > height {
                                        item.appeared = false
                                    } else {
                                        item.appeared = true
                                    }
                                })
                                .onDisappear(perform: {
                                    item.appeared = false
                                })
                                .onTapGesture {
                                    coordinator.selectedItem = item
                                }
                        }
                    }
                    .padding(.vertical, 15)
                }
            }
            .onChange(of: coordinator.selectedItem) { oldValue, newValue in
                if let item = coordinator.items.first(where: {$0.id == newValue?.id}), !item.appeared {
                    //scroll to thies item , ast the is not visiable on the screen
                    reader.scrollTo(item.id, anchor: .bottom)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        
    }
}

extension Home {
    @ViewBuilder
    private func GirdImageView(_ item: Item) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
                    return [item.id + "SOURCE": anchor]
                }
            
            if let previewImage = item.previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
            }
        }
        .frame(height: 130)
        .contentShape(.rect)
    }
}



#Preview {
    ContentView()
}




extension View {
    @ViewBuilder
    func didFrameChange(result: @escaping (CGRect, CGRect) -> Void) -> some View {
        self.overlay {
            GeometryReader {
                let frame = $0.frame(in: .scrollView(axis: .vertical))
                let bounds = $0.bounds(of: .scrollView(axis: .vertical)) ?? .zero
                
                Color.clear
                    .preference(key: FrameKey.self, value: .init(frame: frame, bounds: bounds))
                    .onPreferenceChange(FrameKey.self, perform: { value in
                        result(value.frame, value.bounds)
                    })
                
            }
        }
    }
}


struct ViewFrame:Equatable {
    var frame: CGRect = .zero
    var bounds: CGRect = .zero
}


struct FrameKey: PreferenceKey {
    static func reduce(value: inout ViewFrame, nextValue: () -> ViewFrame) {
        value = nextValue()
    }
    
    static var defaultValue: ViewFrame = .init()
}
