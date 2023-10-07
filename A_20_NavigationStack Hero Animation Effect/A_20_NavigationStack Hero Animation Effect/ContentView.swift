//
//  ContentView.swift
//  A_20_NavigationStack Hero Animation Effect
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedProfile: Profile?
    @State private var pushView: Bool = false
    var body: some View {
        NavigationStack {
            Home(selectedProfile: $selectedProfile, pushView: $pushView)
                .navigationTitle("Profile")
                .navigationDestination(isPresented: $pushView) {
                    if let selectedProfile {
                        DetailView(profile: selectedProfile)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
 
