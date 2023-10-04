//
//  TaskRowView.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct TaskRowView: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var context
    var body: some View {
        HStack(alignment: .top, spacing: 15, content: {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(.circle)
                        .frame(width: 50, height: 50)
//                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(task.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    
                Label(task.createDate.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            })
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern:.solid, color: .black)
            .contentShape(.contextMenuPreview,.rect(cornerRadius: 15))
            .contextMenu(ContextMenu(menuItems: {
                Button(role: .destructive) {
                    context.delete(task)
                    try? context.save()
                } label: {
                    Text("Delete Task")
                }
            }))
            .offset(y: -8)
        })
        .hSpacing(.leading)
    }
    
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        
        return task.createDate.isSameHour ? .darkblue : (task.createDate.isPast ? .red : .black)
    }
    
}

#Preview {
    ContentView()
}
