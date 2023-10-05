//
//  Home.swift
//  A_19_Kanban Drag Drop
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

struct Home: View {
    
    @State private var todo:[Task] = [
        .init(title: "Edit Video", status: .todo)
    ]
    @State private var working:[Task] = [
        .init(title: "Record Video", status: .working)
    ]
    
    @State private var completed:[Task] = [
        .init(title: "Implement Drag & Drop", status: .completed),
        .init(title: "Update Mockview App!", status: .completed),
    ]
    
    @State private var currentDragging: Task?
    
    var body: some View {
        HStack(spacing: 2, content: {
            TodoView()
                .dropDestination(for: String.self) { items, location in
                    // appending to the last of the current list, if the item if not present on that list
                    withAnimation(.snappy) {
                        appendTask(.todo)
                    }
                    return true
                }isTargeted: { _ in
                    
                }
            WorkingView()
                .dropDestination(for: String.self) { items, location in
                    withAnimation(.snappy) {
                        appendTask(.working)
                    }
                    return true
                }isTargeted: { _ in
                    
                }
            CompletedView()
                .dropDestination(for: String.self) { items, location in
                    withAnimation(.snappy) {
                        appendTask(.completed)
                    }
                    return true
                }isTargeted: { _ in
                    
                }
        })
    }
    
    
    @ViewBuilder
    func TodoView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TasksView(todo)
            }
            .navigationTitle("Todo")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
        }
    }
    
    @ViewBuilder
    func WorkingView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TasksView(working)
            }
            .navigationTitle("Working")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
        }
    }
    
    @ViewBuilder
    func CompletedView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TasksView(completed)
            }
            .navigationTitle("Completed")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
        }
    }
    
}

extension Home {
    @ViewBuilder
    func TasksView(_ task:[Task]) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            ForEach(task) { task in
                GeometryReader(content: {
                    TaskRow(task, $0.size)
                })
                .frame(height: 45)
            }
        })
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    func TaskRow(_ task: Task, _ size: CGSize) -> some View {
        Text(task.title)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity,alignment: .leading)
            .frame(height: size.height)
            .background(.white, in: .rect(cornerRadius: 10))
            .contentShape(.dragPreview, .rect(cornerRadius: 10))
            .draggable(task.id.uuidString) {
                Text(task.title)
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .frame(width: size.width,height: size.height, alignment: .leading)
                    .background(.white)
                    .contentShape(.dragPreview, .rect(cornerRadius: 10))
                    .onAppear {
                        currentDragging = task
                    }
            }
            .dropDestination(for: String.self) { items, location in
                currentDragging = nil
                return false
            }isTargeted: { status in
                appendTask(task.status)
                if let currentDragging, status, currentDragging.id != task.id {
                    withAnimation(.snappy) {
                        switch task.status {
                            
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .working:
                            replaceItem(tasks: &working, droppingTask: task, status: .working)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }
                    }
                }
            }
    }
    
    // appending and removing task from one list to another list
    func appendTask(_ status: TaskStatus) {
        if let currentDragging {
            switch status {
            case .todo:
                // safe check and inserting into list
                if !todo.contains(where: {$0.id == currentDragging.id}) {
                    // updating it's status
                    var updatedTask = currentDragging
                    updatedTask.status = .todo
                    todo.append(updatedTask)
                    working.removeAll(where: {$0.id == currentDragging.id})
                    completed.removeAll(where: {$0.id == currentDragging.id})
                }
            case .working:
                if !working.contains(where: {$0.id == currentDragging.id}) {
                    // updating it's status
                    var updatedTask = currentDragging
                    updatedTask.status = .working
                    working.append(updatedTask)
                    todo.removeAll(where: {$0.id == currentDragging.id})
                    completed.removeAll(where: {$0.id == currentDragging.id})
                }
            case .completed:
                if !completed.contains(where: {$0.id == currentDragging.id}) {
                    // updating it's status
                    var updatedTask = currentDragging
                    updatedTask.status = .completed
                    completed.append(updatedTask)
                    todo.removeAll(where: {$0.id == currentDragging.id})
                    working.removeAll(where: {$0.id == currentDragging.id})
                }
            }
        }
    }
    
    
    
    
    // replacing items within the list
    func replaceItem(tasks: inout [Task],droppingTask: Task, status: TaskStatus) {
        if let currentDragging {
            if let sourceIndex = tasks.firstIndex(where: {$0.id == currentDragging.id}), let destinationIndex = tasks.firstIndex(where: {$0.id == droppingTask.id}) {
                // swapping item's on the list
                var sourceItem = tasks.remove(at: sourceIndex)
                sourceItem.status = status
                tasks.insert(sourceItem, at: destinationIndex)
            }
        }
    }
    
    
}



#Preview {
    ContentView()
}
