//
//  Task.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = UUID.init()
    var title: String
    var create: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}


var sampleTasks:[Task] = [
    .init(title: "Record Video", create: .updateHour(-5), isCompleted: true, tint: .taskcolor),
    .init(title: "Redesign Website", create: .updateHour(-3), isCompleted: false, tint: .taskcolor2),
    .init(title: "Go for a Walk", create: .updateHour(-4), isCompleted: true, tint: .taskcolor3),
    .init(title: "Edit Video", create: .updateHour(-0), isCompleted: true, tint: .taskcolor4),
    .init(title: "Publish Video", create: .updateHour(2), isCompleted: false, tint: .taskcolor),
    .init(title: "Tweet about new Video!", create: .updateHour(1), isCompleted: false, tint: .taskcolor5),
]


extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
