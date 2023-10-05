//
//  Models.swift
//  A_19_Kanban Drag Drop
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

enum TaskStatus {
    case todo
    case working
    case completed
}

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var status: TaskStatus
}
