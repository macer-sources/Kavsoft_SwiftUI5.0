//
//  Home.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Home: View {
    
    @State private var currentDate: Date = .init()
    @State private var weekSilder:[[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @Namespace private var animation
    
    @State private var createNewTask: Bool = false
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0, content: {
            HeaderView()
            WeekSlider()
            TaskView(currentDate: $currentDate)
        })
        .vSpacing(.top)
        .onAppear {
            if weekSilder.isEmpty {
                let currentWeek = Date().fetchWeek()
                if let firstDate = currentWeek.first?.date {
                    weekSilder.append(firstDate.previousWeek())
                }
                weekSilder.append(currentWeek)
                if let lastDate = currentWeek.last?.date {
                    weekSilder.append(lastDate.nextWeek())
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {createNewTask.toggle()}, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.darkblue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
            .padding(15)
        }
        .sheet(isPresented: $createNewTask, content: {
            NewTask()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.bg)
        })
    }
    
    
    // Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, content: {
            HStack(spacing: 5, content: {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.darkblue)
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            })
            .font(.title.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
            
            // Week Silder(可以放在这里，业可以和这个view同级别)
        })
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {}, label: {
                Image(.avator)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            })
        })
        .padding(15)
        .background(.white)
        
    }
    
    
    
    @ViewBuilder
    func WeekSlider() -> some View {
        TabView(selection: $currentWeekIndex,
                content:  {
            ForEach(weekSilder.indices,id:\.self) { index in
                let week = weekSilder[index]
                WeekView(week).tag(index)
//                    .padding(.horizontal, 15)
            }
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 90)
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            // creating when it reaches first/last page
            if newValue == 0 || newValue == (weekSilder.count - 1) {
                createWeek = true
            }
        }
    }
    
    @ViewBuilder
    func WeekView(_ week:[Date.WeekDay]) -> some View {
        HStack(spacing: 0, content: {
            ForEach(week, id:\.id) { day in
                VStack(content: {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.darkblue)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                            
                            // indicator to show, which is today date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        }
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                })
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    // updateing current date
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        })
        .background {
            GeometryReader(content: {
                let minX = $0.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        // when the offset reaches 15 and if the create week is toggled then simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    })
            })
        }
    }
    
    
    // TODO: 实现无限滚动的关键
    func paginateWeek() {
        if weekSilder.indices.contains(currentWeekIndex) {
            if let firstDate = weekSilder[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                // inserting new week at oth and removeing last array item
                weekSilder.insert(firstDate.previousWeek(), at: 0)
                weekSilder.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSilder[currentWeekIndex].last?.date, currentWeekIndex == weekSilder.count - 1 {
                weekSilder.append(lastDate.nextWeek())
                weekSilder.removeFirst()
                currentWeekIndex = weekSilder.count - 2
            }
        }
    }
    
}


#Preview {
    ContentView()
}
