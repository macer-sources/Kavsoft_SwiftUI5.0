//
//  A_41_Custom_In_App_Custom_Notification_sApp.swift
//  A_41_Custom In-App Custom Notification's
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

@main
struct A_41_Custom_In_App_Custom_Notification_sApp: App {
    @State private var overlayWindow: PassThroughWindow?
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    if overlayWindow == nil {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            let overlayWindow = PassThroughWindow(windowScene: windowScene)
                            overlayWindow.backgroundColor = .clear
                            overlayWindow.tag = 0324
                            let controller = StatusBarBasedController()
                            controller.view.backgroundColor = .clear
                            overlayWindow.rootViewController = controller
                            overlayWindow.isHidden = false
                            overlayWindow.isUserInteractionEnabled = true
                            self.overlayWindow = overlayWindow
                            
                            print("Over Window created")
                        }
                    }
                })
        }
    }
}

class StatusBarBasedController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}


// TODO: 没有这个就会事件无响应，被遮挡了
fileprivate class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {return nil}
        return rootViewController?.view == view ? nil : view
    }
}
