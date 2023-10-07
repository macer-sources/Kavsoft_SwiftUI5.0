//
//  Models.swift
//  A_20_NavigationStack Hero Animation Effect
//
//  Created by Kan Tao on 2023/10/7.
//

import SwiftUI

struct Profile: Identifiable {
    var id = UUID().uuidString
    var name: String
    var pic: String
    var lastMsg: String
    var lastActive: String
}


var profiles = [
    Profile.init(name: "iJustine", pic: "avator_1", lastMsg: "hi kavsoft", lastActive: "10:25 PM"),
    Profile.init(name: "Emily", pic: "avator_2", lastMsg: "Nothing", lastActive: "06:25 PM"),
]
