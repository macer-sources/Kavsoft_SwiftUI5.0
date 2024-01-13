//
//  StatusBarView.swift
//  A_42_Changing Status Bar With SwiftUI
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI
import UIKit

struct StatusBarView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var statusBarWindow: UIWindow?
    var body: some View {
        content
            .onAppear(perform: {
                if statusBarWindow == nil {
                    if let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let statusBarWindow = UIWindow(windowScene: windowScene)
                        statusBarWindow.windowLevel = .statusBar
                        statusBarWindow.tag = 0324
                        let controller = StatusBarViewController()
                        controller.view.backgroundColor = .clear
                        controller.view.isUserInteractionEnabled = false
                        
                        statusBarWindow.rootViewController = controller
                        statusBarWindow.isHidden = false
                        statusBarWindow.isUserInteractionEnabled = false
                        self.statusBarWindow = statusBarWindow
                        
                    }
                }
            })
    }
}


class StatusBarViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}


extension UIApplication {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBarWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == 0324}), let statusBarController = statusBarWindow.rootViewController as? StatusBarViewController {
            // updating status bar style
            statusBarController.statusBarStyle = style
            // refreshing change 
            statusBarController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
