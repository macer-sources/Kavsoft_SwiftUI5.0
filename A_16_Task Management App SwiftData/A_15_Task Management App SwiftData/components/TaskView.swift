//
//  TaskView.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI
import SwiftData

struct TaskView: View {
    @Binding var currentDate: Date
    @Query private var tasks:[Task]
    
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        
        
        let predicate = #Predicate<Task> {
            return $0.createDate >= startOfDate && $0.createDate < endOfDate
        }
        let sortDescriptor = [
            SortDescriptor(\Task.createDate , order: .reverse)
        ]
        self._tasks = Query(filter: predicate,sort: sortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
               TasksView()
            }
            .hSpacing(.center)
            .vSpacing(.center)
        }
        .scrollIndicators(.hidden)
    }
}

extension TaskView {
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading,spacing: 35, content: {
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    // TODO: 点之间的🧵
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom , -35)
                        }
                    }
            }
        })
        .padding([.vertical, .leading], 15)
        .padding(.top, 15)
        .overlay {
            if tasks.isEmpty {
                Text("No Task's Found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(width: 150)
                
            }
        }
    }

}


#Preview {
    ContentView()
}

