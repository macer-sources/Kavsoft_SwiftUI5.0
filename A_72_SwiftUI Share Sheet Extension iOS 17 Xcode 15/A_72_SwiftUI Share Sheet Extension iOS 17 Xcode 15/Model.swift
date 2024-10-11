//
//  Model.swift
//  A_72_SwiftUI Share Sheet Extension iOS 17 Xcode 15
//
//  Created by Kan Tao on 2024/10/11.
//

import SwiftUI
import SwiftData
@Model
class ImageItemData {
    @Attribute(.externalStorage)
    var data: Data
    init(data: Data) {
        self.data = data
    }
}
