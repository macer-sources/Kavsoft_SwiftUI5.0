//
//  models.swift
//  A_97_SwiftUI-Scrollable-Tab-Bar
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI
enum Tab: String, CaseIterable {
    case research = "Research"
    case deployment = "Development"
    case analytics = "Analytics"
    case audience = "Audience"
    case privacy = "Privacy"
}

struct TabModel: Identifiable {
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
}
