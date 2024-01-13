//
//  ContentView.swift
//  A_43_Full Swipe Pop Navigation Stack
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct ContentView: View {
    @State private var isEnabled: Bool = false
    var body: some View {
        FullSwipeNavigationStack {
            List {
                Section("Sample Header") {
                    NavigationLink("Full Swipe View") {
                        List {
                            Toggle("Enable Full Swipe Pop", isOn: $isEnabled)
                                .enableFullSwipePop(isEnabled)
                        }
                        .navigationTitle("Full Swipe View")
                    }
                    NavigationLink("Leading Swipe View") {
                        Text("")
                            .navigationTitle("Leading Swipe View")
                    }
                }
            }
            .navigationTitle("Full Swipe Pop")
        }
    }
}

#Preview {
    ContentView()
}
