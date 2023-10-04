//
//  SwiftData.swift
//  A_00_New in SwiftUI5
//
//  Created by Kan Tao on 2023/7/20.
//

import SwiftUI
import SwiftData

@Model
class Person {
    var name: String
    var isLinked: Bool
    var dateAdded: Date
    
    init(name: String, isLinked: Bool = false, dateAdded: Date = Date()) {
        self.name = name
        self.isLinked = isLinked
        self.dateAdded = dateAdded
    }
}


@available(macOS 14.0, *)
struct SwiftData: View {
    @Environment(\.modelContext) private var ctx
    var body: some View {
        NavigationStack {
            List {
                
            }
        }
    }
}

#Preview {
    SwiftData()
}
