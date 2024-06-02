//
//  Custom_Number_PadApp.swift
//  Custom Number Pad
//
//  Created by Kan Tao on 2024/3/23.
//

import SwiftUI

// https://www.youtube.com/watch?v=7Zwow8FptYA
@main
struct Custom_Number_PadApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
