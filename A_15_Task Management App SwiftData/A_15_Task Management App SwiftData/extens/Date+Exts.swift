//
//  Date+Exts.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI


extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }
    
    
    struct WeekDay: Identifiable {
        var id:UUID = .init()
        var date: Date
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week:[WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {return [] }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    
    // createing next week ， based on the last current week's date
    func nextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)  else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    func previousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfDate)  else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
    
    
}





