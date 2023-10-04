//
//  ToggleStateIntent.swift
//  A_05_Interactive Widgets
//
//  Created by Kan Tao on 2023/10/4.
//

import Foundation
import AppIntents


struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task State"
    
    
    @Parameter(title: "Task ID")
    var id: String
    
    
    init() {
        
    }
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        if let index = TaskDataModel.shared.tasks.firstIndex(where: {$0.id == id}) {
            TaskDataModel.shared.tasks[index].isCpmpleted.toggle()
            print("update")
        }
        return .result()
    }
    
}


