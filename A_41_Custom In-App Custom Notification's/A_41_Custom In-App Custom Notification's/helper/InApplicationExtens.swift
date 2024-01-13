//
//  InApplicationExtens.swift
//  A_41_Custom In-App Custom Notification's
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

extension UIApplication {
    func inAppNotification<Content: View>(adaptForDynamicIsland: Bool = false , timeout: CGFloat = 5, swipeToClose:Bool = true, @ViewBuilder content:@escaping () -> Content) {
        // fetching active window via windwoscene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == 0324}) {
            // frame and safearea values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            
            let checkForDynaimicIsland = adaptForDynamicIsland && safeArea.top >= 51
            
            var tag: Int = 1009
            if let previousTag = UserDefaults.standard.value(forKey: "in_app_notification_tag") as? Int {
                tag = previousTag + 1
            }
            UserDefaults.standard.setValue(tag, forKey: "in_app_notification_tag")
            
            // changing status into black to blend with dynamic island
            if checkForDynaimicIsland {
                if let controller = activeWindow.rootViewController as? StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
            
            
            // createing uiview from swiftuiView using UIHosting Configuration
            let config = UIHostingConfiguration {
                AnimatedNotificationView(content: content(),
                                         safeArea: safeArea,
                                         tag: tag,
                                         adaptForDynamicIsland: checkForDynaimicIsland,
                                         timeout: timeout,
                                         swipeToClose: swipeToClose)
                .frame(width: frame.width - (checkForDynaimicIsland ? 20 :  30), height: 120, alignment: .top)
                    .contentShape(.rect)
            }
            
            // creating uiview
            let view = config.makeContentView()
            view.backgroundColor = .clear
            view.tag = tag
            view.translatesAutoresizingMaskIntoConstraints = false
            if let rootView = activeWindow.rootViewController?.view {
                rootView.addSubview(view)
                
                // Layout Constraints
                view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor, constant: (-(frame.height - safeArea.top ) / 2) + (checkForDynaimicIsland ? 11 : safeArea.top)).isActive = true
                
            }

        }
    }
}

fileprivate struct AnimatedNotificationView<Content: View>: View {
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    
    // view properties
    @State private var animateNotification: Bool = false
    
    var body: some View {
        content
            .blur(radius: animateNotification ? 0 : 10)
            .disabled(!animateNotification)
            .mask {
                if adaptForDynamicIsland {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        let radius = size.height / 2
                        RoundedRectangle(cornerRadius: radius)
                    })
                    
                }else {
                    Rectangle()
                }
            }
            // scaleing animation only for dynimic notification
            .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.5))
            // offset animation for no dynamic island notification
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if -value.translation.height > 50 && swipeToClose {
                            withAnimation( .smooth,completionCriteria: .logicallyComplete) {
                                animateNotification = false
                            } completion: {
                                removeNotificationViewFromWindow()
                            }
                        }
                    })
            )
            .onAppear(perform: {
                Task {
                    guard !animateNotification else {return}
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    // Timeout for notification
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    guard animateNotification else {return}
                    
                    withAnimation( .smooth,completionCriteria: .logicallyComplete) {
                        animateNotification = false
                    } completion: {
                        removeNotificationViewFromWindow()
                    }

                }
            })
    }
    
    var offsetY: CGFloat {
        if adaptForDynamicIsland {
            return 0
        }
        return animateNotification ? 10 : -(safeArea.top + 130)
    }
    
    func removeNotificationViewFromWindow() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == 0324}) {
            if let view = activeWindow.viewWithTag(tag) {
                view.removeFromSuperview()
                // resetting once all the notifications we removed
                if let controller = activeWindow.rootViewController as? StatusBarBasedController, controller.view.subviews.isEmpty {
                    controller.statusBarStyle = .default
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
}

