//
//  ContentView.swift
//  Hacker Text Effect
//
//  Created by Kan Tao on 2024/6/2.
//

import SwiftUI

struct ContentView: View {
    @State private var trigger: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HackerTextView(text: "Made With SwiftUI\n By @Kavsoft", 
                           trigger: trigger,
                           transition: .interpolate,
                           speed: 0.06)
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            Button(action: {trigger.toggle()}, label: {
                Text("Trigger")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 2)
            })
            .buttonBorderShape(.capsule)
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
