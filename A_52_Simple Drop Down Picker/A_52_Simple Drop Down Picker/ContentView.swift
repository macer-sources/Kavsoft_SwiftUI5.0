//
//  ContentView.swift
//  A_52_Simple Drop Down Picker
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct ContentView: View {
    
    //
    @State private var selection: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15, content: {
                DropDownView(hint: "Select", 
                             options: [
                                "YouTube",
                                "Instagram",
                                "X (Twitter)",
                                "Snapchat",
                                "TikTok"
                            ],
                             anchor: .bottom,
                             selection: $selection)
            })
            .navigationTitle("Dropdown Picker")
        }
    }
}

#Preview {
    ContentView()
}
