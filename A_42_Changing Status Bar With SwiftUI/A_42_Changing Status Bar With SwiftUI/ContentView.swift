//
//  ContentView.swift
//  A_42_Changing Status Bar With SwiftUI
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

enum StatusBarStyle: String, CaseIterable {
    case defualt = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .defualt:
            return .default
        case .light:
            return .lightContent
        case .dark:
            return .darkContent
        }
    }
}
struct ContentView: View {
    @State private var statusBarStyle = StatusBarStyle.defualt
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $statusBarStyle) {
                    ForEach(StatusBarStyle.allCases, id: \.rawValue) { item in
                        Text(item.rawValue)
                            .tag(item)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: statusBarStyle, initial: false, { oldValue, newValue in
                    UIApplication.shared.setStatusBarStyle(newValue.statusBarStyle)
                })
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
