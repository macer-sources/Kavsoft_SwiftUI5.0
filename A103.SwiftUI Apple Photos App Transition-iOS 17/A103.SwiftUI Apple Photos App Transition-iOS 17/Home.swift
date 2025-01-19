//
//  Home.swift
//  A103.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/2.
//

import SwiftUI

struct Home: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3) {
                ForEach(coordinator.items) { item in
                    GirdImageView(item)
                        .onTapGesture {
                            coordinator.selectedItem = item
                        }
                }
            }
            .padding(.vertical, 15)
        }
        .navigationTitle("Recents")
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
