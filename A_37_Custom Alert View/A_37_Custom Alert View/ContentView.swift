//
//  ContentView.swift
//  A_37_Custom Alert View
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

struct ContentView: View {
    @State private var alert: AlertConfig = .init()
    @State private var alert1: AlertConfig = AlertConfig(slideEdge: .top)
    var body: some View {
        VStack {
            Button(action: {
                alert.present()
                alert1.present()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    alert1.present()
//                }
            }, label: {
                Text("Button")
            })
        }
        .padding()
        .alert(alertConfig: $alert) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.red.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert.dismiss()
                }
        }
        .alert(alertConfig: $alert1) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert1.dismiss()
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(SceneDelegate())
}
