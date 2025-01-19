//
//  ContentView.swift
//  A104.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/6.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var coordinator: UICoordinator = .init()
    var body: some View {
        NavigationStack {
            Home()
                .environment(coordinator)
                .allowsHitTesting(coordinator.selectedItem == nil)
        }
        .overlay(content: {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(coordinator.animateView ? 1 : 0)
        })
        .overlay {
            if coordinator.selectedItem != nil {
                DetailView()
                    .environment(coordinator)
                    .allowsHitTesting(coordinator.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self) { value in
            if let selectedItem = coordinator.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"]
            {
                HeroLayer(item: selectedItem, sAnchor: sAnchor, dAnchor: dAnchor)
                    .environment(coordinator)
            }
        }
    }
}

#Preview {
    ContentView()
}
