//
//  Item.swift
//  A_17_Repeatable Button KeyFrames
//
//  Created by Kan Tao on 2023/10/5.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
