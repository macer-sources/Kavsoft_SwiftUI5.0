//
//  A_42_Changing_Status_Bar_With_SwiftUIApp.swift
//  A_42_Changing Status Bar With SwiftUI
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

@main
struct A_42_Changing_Status_Bar_With_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            StatusBarView {
                ContentView()
            }
        }
    }
}
