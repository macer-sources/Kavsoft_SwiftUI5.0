//
//  Models.swift
//  SwiftUI Stacked ScrollView
//
//  Created by Kan Tao on 2024/6/3.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = UUID()
    var logo: Color = .red
    var title: String
    var description: String
}

var items:[Item] = [
    .init(title: "Amazon", description: "Amazon"),
    .init(title: "Youtube", description: "Youtube"),
    .init(title: "Dribble", description: "Dribble"),
    .init(title: "Apple", description: "Apple"),
    .init(title: "Patreon", description: "Patreon"),
    .init(title: "Netflix", description: "AmazNetflixon"),
    .init(title: "Figma", description: "Figma"),
]
