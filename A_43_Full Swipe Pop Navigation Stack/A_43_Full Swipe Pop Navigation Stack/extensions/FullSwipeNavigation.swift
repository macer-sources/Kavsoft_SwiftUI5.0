//
//  FullSwipeNavigation.swift
//  A_43_Full Swipe Pop Navigation Stack
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct FullSwipeNavigationStack<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var customGesuture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = false
        return gesture
    }()
    var body: some View {
        NavigationStack {
            content
                .background {
                    AttachGestureView(gesture: $customGesuture)
                }
        }
        .environment(\.popGestureID, customGesuture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesuture.name ?? "")), perform: { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesuture.isEnabled = status
            }
        })
    }
}


// Custom Environment Key for passing Gesture ID to it's subviews
fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}
fileprivate extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

extension View {
    @ViewBuilder
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        self
            .modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}
// Helper View Modifier
fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled:Bool
    // gesture id
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { oldValue, newValue in
                guard let gestureID = gestureID else {return}
                NotificationCenter.default.post(name: .init(rawValue: gestureID), object: nil, userInfo: ["status": newValue])
            }
            .onDisappear(perform: {
                guard let gestureID = gestureID else {return}
                NotificationCenter.default.post(name: .init(rawValue: gestureID), object: nil, userInfo: ["status": false])
            })
    }
}




// helpers files
fileprivate struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            // finding parent controller
            if let parentViewController = uiView.parentViewController {
                if let navigationController = parentViewController.navigationController {
                    // checking if already the gesutre has been added to the controller
                    if let _ = navigationController.view.gestureRecognizers?.first(where: {$0.name == gesture.name}) {
                        print("Already Attached")
                    }else {
                        navigationController.addFullSwipeGesture(gesture)
                        print("Attached")
                    }
                }
            }
        }
    }
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first(where: {$0 is UIViewController}) as? UIViewController
    }
}

fileprivate extension UINavigationController {
    /// adding custom fullswipe gesture
    // https:// stackoverflow.com/questions/20714595/extend-default-interactivepopgesturerecognizer-beyond-screen-edge
    func addFullSwipeGesture(_ gesture:UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else {return}
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}



#Preview {
    ContentView()
}
