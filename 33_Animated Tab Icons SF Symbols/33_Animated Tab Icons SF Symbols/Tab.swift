//
//  Tab.swift
//  33_Animated Tab Icons SF Symbols
//
//  Created by Kan Tao on 2024/1/2.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case photos = "photo.stack"
    case chat = "bubble.left.and.text.bubble.right"
    case apps = "square.3.layers.3d"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person.2.crop.square.stack.fill"
    
    var title: String {
        switch self {
        case .photos:
            return "Photos"
        case .chat:
            return "Chat"
        case .apps:
            return "Apps"
        case .notifications:
            return "Notifications"
        case .profile:
            return "Profile"
        }
    }
}


// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = UUID()
    var tab: Tab
    var isAnimating: Bool?
}
