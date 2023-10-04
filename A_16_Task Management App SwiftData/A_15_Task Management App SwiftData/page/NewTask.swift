//
//  NewTask.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var date: Date = .init()
    @State private var color: String = "taskcolor1"
    
    // model context for saving data
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            HStack(content: {
                Text("New Task")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {dismiss()}, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .tint(.red)
                })
                .hSpacing(.trailing)
            })
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Go for a Walk!", text: $title)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            }
            .padding(.top, 5)
            
            HStack(spacing: 12, content: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $date)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                }
                .padding(.top, 5)
                .padding(.trailing, -15)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    let colors:[String] = (1...5).compactMap { index -> String in
                        return "taskcolor\(index)"
                    }
                    
                    HStack(spacing: 0, content: {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 20, height: 20)
                                .background {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(self.color == color ? 1 : 0)
                                }
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation {
                                        self.color = color
                                    }
                                }
                        }
                    })
                }
                
            })
            .padding(.top, 5)
            
            Spacer()
            
            Button {
                // saving date
                let task = Task.init(title: title,create: date, tint: color)
                
                do {
                    context.insert(task)
                    try context.save()
                    dismiss()
                }catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color(color), in:.rect(cornerRadius: 10))
            }
            .disabled(title == "")
            .opacity(title == "" ? 0.5 : 1)

            
        })
        .padding(15)
    }
}

#Preview {
    NewTask()
        .vSpacing(.bottom)
}
