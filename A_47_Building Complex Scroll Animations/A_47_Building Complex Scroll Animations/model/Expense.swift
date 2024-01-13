//
//  Expense.swift
//  A_47_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI


// sample expense

struct Expense: Identifiable {
    var id = UUID()
    var amountSpent: String
    var product: String
    var spendType: String
}


var expenses:[Expense] = [
    .init(amountSpent: "$128", product: "Amazon Purchase", spendType: "Groceries"),
    .init(amountSpent: "$10", product: "Youtube Proemius", spendType: "Streaming"),
    .init(amountSpent: "$10", product: "Dribble", spendType: "Nembership"),
    .init(amountSpent: "$199", product: "Magic Keyboard", spendType: "products"),
    .init(amountSpent: "$9", product: "Patreon", spendType: "Nembership"),
    .init(amountSpent: "$100", product: "Instagram", spendType: "Ad Puhlish"),
    .init(amountSpent: "$14", product: "Netflix", spendType: "Streaming"),
    .init(amountSpent: "$348", product: "Photoshop", spendType: "Editing"),
    .init(amountSpent: "$99", product: "Figma", spendType: "Pro Member"),
    .init(amountSpent: "$99", product: "Magic Mouse", spendType: "products"),
    .init(amountSpent: "$1200", product: "Studio Display", spendType: "Products"),
    .init(amountSpent: "$39", product: "Sketch Subscription", spendType: "Membership"),
]
