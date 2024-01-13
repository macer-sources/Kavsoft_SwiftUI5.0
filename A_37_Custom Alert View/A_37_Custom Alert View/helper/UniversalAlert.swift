//
//  UniversalAlert.swift
//  A_37_Custom Alert View
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI




enum TransitionType {
    case slide
    case opcity
}
// Alert Config
struct AlertConfig {
    fileprivate var enableBackgroundBlur: Bool = true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType:TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    
    // private properties
    fileprivate var show:Bool = false
    fileprivate var showView: Bool = false
    
    mutating
    func present() {
        show = true
    }
    mutating
    func dismiss() {
        show = false
    }
    
    init(enableBackgroundBlur: Bool = true, disableOutsideTap: Bool = true , transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
}


@Observable
class AppDelegate:NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        // setting scene delegate class
        config.delegateClass = SceneDelegate.self
        return config
    }
}


@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var overlayWindow: UIWindow?
    var tag: Int = 0
    
    var alerts:[UIView] = []
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
        setupOverlayWindow()
    }
    
    // Adding overlay window to handle all our alerts on the top of the current window
    private func setupOverlayWindow() {
        guard let windowScene = windowScene else {return}
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        self.overlayWindow = window
    }
}


extension SceneDelegate {
    fileprivate func alert<Content: View>(config: Binding<AlertConfig>,@ViewBuilder content:@escaping () -> Content, viewTag: @escaping (Int) -> Void) {
        guard let alerWindow = overlayWindow else {return}
        let viewController = UIHostingController(rootView: AlertView(config: config, tag: tag, content: {
            content()
        }))
        viewController.view.backgroundColor = .clear
        viewController.view.tag = tag
        viewTag(tag)
        tag += 1
        
        if alerWindow.rootViewController == nil {
            alerWindow.rootViewController = viewController
            alerWindow.isHidden = false
            alerWindow.isUserInteractionEnabled = true
            
        }else {
//            print("Exisiting Alert is Still Present")
            viewController.view.frame = alerWindow.rootViewController?.view.frame ?? .zero
            alerts.append(viewController.view)
        }
    }
}

extension View {
    @ViewBuilder
    func alert<Content: View>(alertConfig: Binding<AlertConfig>, @ViewBuilder  content:@escaping () -> Content) -> some View {
        self
            .modifier(AlertModifier(config: alertConfig, alertContent: content))
    }
}

// alert handling view modifier
fileprivate struct AlertModifier<AlertContent: View>: ViewModifier {
    @Binding var config: AlertConfig
    @ViewBuilder var alertContent:() -> AlertContent
    // scene delegate
    @Environment(SceneDelegate.self) private var sceneDelegate
    @State private var viewTag: Int = 0
    func body(content: Content) -> some View {
        content
        // TODO: 此处决定是否显示
            .onChange(of: config.show, initial: false) { oldValue, newValue in
                if newValue {
                    // simply call the function we implemented on sceneDelegate
                    sceneDelegate.alert(config: $config
                                        , content: alertContent) { tag in
                        viewTag = tag
                    }
                }else {
                    // 隐藏操作
                    guard let alertWindow = sceneDelegate.overlayWindow else {return}
                    if config.showView {
                        withAnimation(.smooth()) {
                            config.showView = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            if sceneDelegate.alerts.isEmpty {
                                alertWindow.rootViewController = nil
                                alertWindow.isHidden = true
                                alertWindow.isUserInteractionEnabled = false
                            }else {
                                // presenting next alert
                                // removing the preview view
                                if let first = sceneDelegate.alerts.first {
                                    alertWindow.rootViewController?.view.subviews.forEach({ view in
                                        view.removeFromSuperview()
                                    })
                                    
                                    alertWindow.rootViewController?.view.addSubview(first)
                                    // removing the added alert from the array
                                    sceneDelegate.alerts.removeFirst()
                                }
                            }

                        }
                    }else {
                        print("view is not appeared")
                        // removing the view from the array with the help of view tag
                        sceneDelegate.alerts.removeAll(where: {$0.tag == viewTag })
                    }
                }
            }
    }
}



fileprivate struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    // view tag
    var tag: Int
    @ViewBuilder var content:() -> Content
    
    @State private var showView: Bool = false
     
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)
            
            if showView && config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            }else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
                
            }
        })
        .onAppear {
            config.showView = true
        }
        .onChange(of: config.showView) { oldValue, newValue in
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                showView = newValue
            }
        }
    }
}
