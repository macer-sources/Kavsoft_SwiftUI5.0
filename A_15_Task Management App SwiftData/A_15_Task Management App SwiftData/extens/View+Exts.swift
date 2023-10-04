//
//  View+Exts.swift
//  A_15_Task Management App SwiftData
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI
 

extension View {
    
    // custom spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    
    // checking two dates are same
    func isSameDate(_ date: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: date2)
    }
}
