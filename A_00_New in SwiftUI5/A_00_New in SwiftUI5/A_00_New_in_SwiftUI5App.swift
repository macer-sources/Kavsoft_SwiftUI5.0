//
//  A_00_New_in_SwiftUI5App.swift
//  A_00_New in SwiftUI5
//
//  Created by Kan Tao on 2023/7/20.
//

import SwiftUI

@main
struct A_00_New_in_SwiftUI5App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
