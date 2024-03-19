//
//  ContentView.swift
//  A_Horizontal Wheel Picker
//
//  Created by Kan Tao on 2024/3/19.
//

import SwiftUI

struct ContentView: View {
    @State private var config = WheelPicker.Config.init(count: 30)
    @State private var value:CGFloat = 0
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                    Text(verbatim: "\(value)")
                        .font(.largeTitle.bold())
                        .contentTransition(.numericText(value: value))
                        .animation(.snappy, value: value)
                    
                    Text("lbs")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    // TODO: 测试代码
                    Button("Update") {
                        withAnimation {
                            value = 12
                        }
                    }
                })
                .padding(.bottom, 30)
                
                WheelPicker(config: config, value: $value)
                    .frame(height: 60)
            }
            .navigationTitle("Wheel Picker")
        }
    }
}

#Preview {
    ContentView()
}
