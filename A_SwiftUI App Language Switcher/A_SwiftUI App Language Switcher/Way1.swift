//
//  Way1.swift
//  A_SwiftUI App Language Switcher
//
//  Created by Kan Tao on 2024/3/20.
//

import Foundation

//enum Language: String, Identifiable, CaseIterable {
//    case system = ""
//    case english = "en"
//    case chinese = "zh-Hans"
//
//    var id:String {
//        switch self {
//        case .english:
//            "en"
//        case .chinese:
//            "zh-Hans"
//        default:
//            "System"
//        }
//    }
//    var name: String {
//        switch self {
//        case .english:
//            "English"
//        case .chinese:
//            "简体中文"
//        case .system:
//            "System"
//        }
//    }
//    var locale: Locale {
//        switch self {
//        case .system:
//            return .init(identifier: "en")
//        case .english:
//            return .init(identifier: "en")
//        case .chinese:
//            return .init(identifier: "zh-Hans")
//        }
//    }
//}
//
//extension String {
//
//  var localized: String {
//      // TODO: 上边枚举不指定类型，这里就需要先转为枚举，然后再获取枚举的 id 才能时 res
//    let res = UserDefaults.standard.string(forKey: "language")
//    let path = Bundle.main.path(forResource: res, ofType: "lproj")
//    let bundle: Bundle
//    if let path = path {
//      bundle = Bundle(path: path) ?? .main
//    } else {
//      bundle = .main
//    }
//    return NSLocalizedString(self, bundle: bundle, value: "", comment: "")
//  }
//}
//
//
