//
//  ScreenshotPreventView.swift
//  A_18_Prevent Screenshot
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

struct ScreenshotPreventView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    @State private var hostingController: UIHostingController<Content>?
    
    var body: some View {
        _ScreenshotPreventHelper(hostingController: $hostingController).overlay {
            GeometryReader(content: {
                let size = $0.size
                Color.clear
                    .preference(key: SizeKey.self, value: size)
                    .onPreferenceChange(SizeKey.self, perform: { value in
                        if value != .zero {
                            // creating hosting controller with the size
                            if hostingController == nil {
                                hostingController = UIHostingController(rootView: content)
                                hostingController?.view.backgroundColor = .clear
                                hostingController?.view.tag = 1009
                                hostingController?.view.frame = .init(origin: .zero, size: value)
                            }else {
                                // sometime the view size may updated, in that case updating size
                                hostingController?.view.frame = .init(origin: .zero, size: value)
                            }
                        }
                    })
            })
        }
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}



fileprivate struct _ScreenshotPreventHelper<Content: View> : UIViewRepresentable {
    @Binding var hostingController: UIHostingController<Content>?
    
    func makeUIView(context: Context) -> some UIView {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        if let textLayoutView = secureField.subviews.first {
            return textLayoutView
        }
        return UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // adding hosting view as a subview to the textlayout view
        if let hostingController, !uiView.subviews.contains(where: {$0.tag == 1009}) {
            // adding hosting controller for one time
            uiView.addSubview(hostingController.view)
        }
    }
}







#Preview {
    ContentView()
}
