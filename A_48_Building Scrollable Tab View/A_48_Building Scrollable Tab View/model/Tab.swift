//
//  Tab.swift
//  A_48_Building Scrollable Tab View
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .chats:
            return "bubble.left.and.bubble.right"
        case .calls:
            return "phone"
        case .settings:
            return "gear"
        }
    }
}
