//
//  Task.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI
import SwiftData

@Model
class Task: Identifiable {
    var id: UUID
    var title: String
    var createDate: Date
    var isCompleted: Bool = false
    var tint: String
    
    init(id: UUID = .init(), title: String, create: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.title = title
        self.createDate = create
        self.isCompleted = isCompleted
        self.tint = tint
    }
    
    var tintColor: Color {
        switch tint {
        case "taskcolor1": return .taskcolor1
        case "taskcolor2": return .taskcolor2
        case "taskcolor3": return .taskcolor3
        case "taskcolor4": return .taskcolor4
        case "taskcolor5": return .taskcolor5
        default:
            return .black
        }
    }
}




extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
