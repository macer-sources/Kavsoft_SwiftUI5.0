//
//  Home.swift
//  A_50_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct Home: View {
    var safeArea: EdgeInsets
    
    @State private var selectedMonth: Date = .currentMonth
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0, content: {
                
                CalenderView()
                
                VStack(spacing: 15, content: {
                    ForEach(1...15, id:\.self) { _ in
                        CardView()
                    }
                })
                .padding(15)
            })
        }
        .scrollIndicators(.hidden)
    }
}


extension Home {
    @ViewBuilder
    func CardView() -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.blue.gradient)
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12, content: {
                    Circle()
                        .frame(width: 40, height: 40, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 100, height: 5)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                        
                    })
                })
                .foregroundStyle(.white.opacity(0.25))
                .padding(.horizontal,15)
            }
            
    }
}




// MARK: Calender View
extension Home {
    @ViewBuilder
    func CalenderView() -> some View {
        VStack(alignment:.leading, spacing: 0) {
            Text(currentMonth)
                .font(.system(size: 35))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .overlay(alignment: .topLeading, content: {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        
                        Text(currentYear)
                            .font(.system(size: 25))
                    })
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .topTrailing, content: {
                    HStack(spacing: 15, content: {
                        Button("", systemImage: "chevron.left") {
                            // update to previous month
                            monthUpdate(false)
                        }
                        .contentShape(.rect)
                        Button("", systemImage: "chevron.right") {
                            // update to next month
                            monthUpdate(true)
                        }
                        .contentShape(.rect)
                    })
                    .foregroundStyle(.primary)
                })
                .frame(height: calendarTitleViewHeight)
            
            // TODO Day labels
            VStack(spacing: 0, content: {
                HStack(spacing: 0, content: {
                    ForEach(Calendar.current.weekdaySymbols, id: \.self) { symbol in
                        Text(symbol.prefix(3))
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
                    }
                })
                .frame(height: weekLabelHeight, alignment: .bottom)
                
                
                // Calendar Grid View
                LazyVGrid(columns: Array.init(repeating: GridItem(spacing: 0), count: 7),spacing: 0, content: {
                    ForEach(selectedMonthDates) { day in
                        Text(day.shortSymbol)
                            .foregroundStyle(day.ignored ? .secondary : .primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .contentShape(.rect)
                    }
                })
                .frame(height: calendarGridHeight)
//                .background(.blue)
                
            })
            
            
            
        }
        .foregroundStyle(.white)
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.top, safeArea.top)
        .background(.red.gradient)
        
    }
     
    // view heights & padding
    var calendarTitleViewHeight: CGFloat {
        return 75.0
    }
    var horizontalPadding: CGFloat {
        return 15.0
    }
    var topPadding: CGFloat {
        return 15.0
    }
    var bottomPadding: CGFloat {
        return 5.0
    }
    
    var weekLabelHeight: CGFloat {
        return 30.0
    }
    
    var calendarGridHeight: CGFloat {
        return CGFloat(selectedMonthDates.count / 7) * 50
    }
    
    
    var currentMonth: String {
        return format("MMMM")
    }
    var currentYear: String {
        return format("YYYY")
    }
    

    // selected month dates
    var selectedMonthDates:[Day] {
        return extractDates(selectedMonth)
    }
            
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: selectedMonth)
    }
    
    // month increment/decrement
    func monthUpdate(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth) else {
            return
        }
        selectedMonth = month
    }
    
}

extension Date {
    static var currentMonth: Date {
        let calender = Calendar.current
        guard let currentMonth = calender.date(from: Calendar.current.dateComponents([.month,.year], from: .now)) else {
            return .now
        }
        return currentMonth
    }
}
extension View {
    // extracting dates for the given month
    func extractDates(_ month: Date) -> [Day] {
        var days:[Day] = []
        let calender = Calendar.current
        guard let range = calender.range(of: .day, in: .month, for: month)?.compactMap({ value -> Date? in
            return calender.date(byAdding: .day, value: value - 1, to: month)
        }) else {
            return days
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        
        // 获取这个月的第一天是周几
        let firstWeekDay = calender.component(.weekday, from: range.first!)
        // 填充前面的几天为上个月的日期
        for index in Array(0..<firstWeekDay - 1).reversed() {
            guard let date = calender.date(byAdding: .day, value: -index - 1, to: range.first!) else {return days}
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
        }
        

        range.forEach { date in
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date))
        }
        
        // 填充下个月的日期
        // 获取这个月的第一天是周几
        let lastWeekDay = 7 - calender.component(.weekday, from: range.last!)
        
        guard lastWeekDay > 0 else {
            return days
        }
        
        // 填充前面的几天为上个月的日期
        for index in 0..<lastWeekDay {
            guard let date = calender.date(byAdding: .day, value: index + 1, to: range.last!) else {return days}
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
        }
        
        
        return days
    }
}

struct Day: Identifiable {
    var id = UUID()
    var shortSymbol: String
    var date: Date
    // previouse/next month excess dates(上个月和下个月的忽略掉)
    var ignored: Bool = false
}


#Preview {
    ContentView()
}
