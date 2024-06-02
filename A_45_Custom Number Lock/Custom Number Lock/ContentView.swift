//
//  ContentView.swift
//  Custom Number Lock
//
//  Created by Kan Tao on 2024/1/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LockView(lockType: .both, lockPin: "0320", isEnabled: true) {
            VStack(spacing: 10, content: {
                Image(systemName: "globe")
                    .imageScale(.large)
                
                Text("Hello World")
            })
        }
    }
}

#Preview {
    ContentView()
}
