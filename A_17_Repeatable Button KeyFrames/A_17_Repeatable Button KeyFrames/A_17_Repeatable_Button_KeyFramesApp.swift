//
//  A_17_Repeatable_Button_KeyFramesApp.swift
//  A_17_Repeatable Button KeyFrames
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI
import SwiftData

@main
struct A_17_Repeatable_Button_KeyFramesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
