//
//  Way2.swift
//  A_SwiftUI App Language Switcher
//
//  Created by Kan Tao on 2024/3/20.
//

import Foundation

enum Language: String, Identifiable, CaseIterable {
    case system = ""
    case english
    case chinese

    var id:String {
        return self.rawValue
    }
    var name: String {
        switch self {
        case .english:
            "English"
        case .chinese:
            "简体中文"
        case .system:
            "System"
        }
    }
    var locale: Locale {
        switch self {
        case .system:
            guard let bundleLanguage = Bundle.main.preferredLocalizations.first else {return .init(identifier: "en")}
            return .init(identifier: bundleLanguage)
        case .english:
            return .init(identifier: "en")
        case .chinese:
            return .init(identifier: "zh-Hans")
        }
    }
}

extension String {

  var localized: String {
      // TODO: 上边枚举不指定类型，这里就需要先转为枚举，然后再获取枚举的 id 才能时 res
    let res = UserDefaults.standard.string(forKey: "language")
      let languageType = Language.init(rawValue: res ?? "") ?? .system
      let path = Bundle.main.path(forResource: languageType.locale.identifier, ofType: "lproj")
    let bundle: Bundle
    if let path = path {
      bundle = Bundle(path: path) ?? .main
    } else {
      bundle = .main
    }
    return NSLocalizedString(self, bundle: bundle, value: "", comment: "")
  }
}


