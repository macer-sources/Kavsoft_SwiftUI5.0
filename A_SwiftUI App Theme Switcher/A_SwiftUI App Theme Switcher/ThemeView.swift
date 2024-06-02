//
//  ThemeView.swift
//  A_SwiftUI App Theme Switcher
//
//  Created by Kan Tao on 2024/3/20.
//

import SwiftUI

extension Color {
    static let bg = Color("Color")
}


enum SchemeType: Int, Identifiable, CaseIterable {
    var id: Self {self}
    case system
    case light
    case dark
}

extension SchemeType {
    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}



struct ThemeView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @AppStorage("systemThemeVal") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    
    
    private var selectedScheme: ColorScheme? {
        guard let theme = SchemeType(rawValue: systemTheme) else {return nil}
        switch theme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            Picker("",selection: $systemTheme) {
                ForEach(SchemeType.allCases, id:\.id) { item in
                    Text(item.title)
                        .tag(item.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .padding()
            .background(.white, in: RoundedRectangle.init(cornerRadius: 8))

        }
        .ignoresSafeArea()
        .environment(\.colorScheme, selectedScheme ?? .light)
//        .preferredColorScheme(selectedScheme)
      
    }
}


extension ThemeView {
    func changeDarkMode(state: Bool){
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = state ? .dark : .light
        //
    }
}


#Preview {
    ThemeView()
}
