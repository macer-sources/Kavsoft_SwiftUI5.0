//
//  ContentView.swift
//  A_SwiftUI App Language Switcher
//
//  Created by Kan Tao on 2024/3/20.
//

import SwiftUI



struct ContentView: View {
    @AppStorage("language") var language:Language = .system

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome".localized)
            
            Picker("", selection: $language) {
                ForEach(Language.allCases, id:\.id) { item in
                    Text(item.name)
                        .tag(item)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .padding()
            .background(.white, in: RoundedRectangle.init(cornerRadius: 8))
        }
        .padding()
        .environment(\.locale,language.locale)
    }
}

#Preview {
    ContentView()
}

