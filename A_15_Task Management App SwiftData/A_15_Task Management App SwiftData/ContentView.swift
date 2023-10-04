//
//  ContentView.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        Home()
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(.bg)
            .preferredColorScheme(.light)
    }

}

#Preview {
    ContentView()
}
