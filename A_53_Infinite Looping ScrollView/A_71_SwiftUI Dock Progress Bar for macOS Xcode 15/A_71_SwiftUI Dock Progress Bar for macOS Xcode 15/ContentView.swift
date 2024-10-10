//
//  ContentView.swift
//  A_71_SwiftUI Dock Progress Bar for macOS Xcode 15
//
//  Created by Kan Tao on 2024/10/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DockProgress.shared
    var body: some View {
        VStack(spacing: 20, content: {
            Picker("", selection: $viewModel.type) {
                ForEach(DockProgress.ProgressType.allCases, id:\.rawValue) {item in
                    Text(item.rawValue)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            
            Toggle("Show Dock Progress", isOn: $viewModel.isVisiable)
                .toggleStyle(.switch)
        })
        .padding(15)
        .frame(width: 200, height: 200)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            guard viewModel.isVisiable else {return}
            if viewModel.progress >= 1.0 {
                viewModel.isVisiable = false
                viewModel.progress = .zero
            } else {
                viewModel.progress += 0.007
            }
        })
    }
}

#Preview {
    ContentView()
}
