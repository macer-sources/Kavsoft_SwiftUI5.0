//
//  WidgetExtensions.swift
//  WidgetExtensions
//
//  Created by Kan Tao on 2023/10/4.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        // customize your placeholder view here
        TaskEntry(lastThreeTask: Array(TaskDataModel.shared.tasks.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry =  TaskEntry(lastThreeTask: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let lastTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let taskEntrys = [TaskEntry(lastThreeTask: lastTasks)]
        let timeline = Timeline(entries: taskEntrys, policy: .atEnd)
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTask:[TaskModel]
}

struct WidgetExtensionsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0, content: {
                Text("Task's")
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading,spacing: 6, content: {
                    if entry.lastThreeTask.isEmpty {
                        Text("No Task's Found")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }else {
                        ForEach(entry.lastThreeTask) {task in
                            HStack(spacing: 6, content: {
                                Image(systemName: task.isCpmpleted ? "checkmark.circle.fill": "circle")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4, content: {
                                    Text(task.taskTitle)
                                        .textScale(.secondary)
                                        .lineLimit(1)
                                        .strikethrough(task.isCpmpleted, pattern: .solid, color: .primary)// 删除线
                                    Divider()
                                })
                            })
                            
                            if task.id != entry.lastThreeTask.last?.id {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                })
            })
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct WidgetExtensions: Widget {
    let kind: String = "WidgetExtensions"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetExtensionsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetExtensionsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Task Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    WidgetExtensions()
} timeline: {
    TaskEntry(lastThreeTask: TaskDataModel.shared.tasks)
}
