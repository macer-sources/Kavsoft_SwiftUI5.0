//
//  DaskModel.swift
//  A_05_Interactive Widgets
//
//  Created by Kan Tao on 2023/10/4.
//

import Foundation



struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCpmpleted: Bool = false
}



class TaskDataModel {
    static let shared = TaskDataModel()
    var tasks:[TaskModel] = [
        .init(taskTitle: "Record Video!"),
        .init(taskTitle: "Edit Video"),
        .init(taskTitle: "Publish it")
    ]
}
