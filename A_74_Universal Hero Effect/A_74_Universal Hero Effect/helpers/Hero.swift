//
//  Hero.swift
//  A_74_Universal Hero Effect
//
//  Created by Kan Tao on 2024/2/8.
//

import SwiftUI

// Hero Wrapper
struct HeroWrapper<Content: View> : View {
    @ViewBuilder var content: Content
    
    // view properties
    @Environment(\.scenePhase)  private var scene
    @State private var overlayWindow: PassthroughWindow?
    @StateObject private var viewModel = HeroViewModel()
    var body: some View {
        content
            .customOnChange(value: scene) { newValue in
                if newValue == .active {
                    addOverayWindow()
                }
            }
            .environmentObject(viewModel)
    }
}

extension HeroWrapper {
    func addOverayWindow() {
        for scene in UIApplication.shared.connectedScenes {
            // finding active scene
            if let windowScene = scene as? UIWindowScene, scene.activationState == .foregroundActive, overlayWindow == nil {
                let window = PassthroughWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.isUserInteractionEnabled = false
                window.isHidden = false
                let rootViewController = UIHostingController(rootView: HeroLayerView().environmentObject(viewModel))
                rootViewController.view.frame = windowScene.screen.bounds
                rootViewController.view.backgroundColor = .clear
                window.rootViewController = rootViewController
                
                self.overlayWindow = window
            }
        }
        
        if overlayWindow == nil {
            print("NO Window Scene Found")
        }
    }
}

fileprivate struct HeroLayerView: View {
    @EnvironmentObject private var viewModel: HeroViewModel
    
    var body: some View {

        GeometryReader(content: { proxy in
            ForEach($viewModel.info) { $info in
                // Retreving Bounds data from the anchor values
                ZStack(content: {
                    if let sourceAnchor = info.sourceAnchor, 
                        let destinationAnchor = info.destinationAnchor,
                       let layerView = info.layerView,
                       !info.hideView
                    {
                        // retreving bounds data from the anchor values
                        let sRect = proxy[sourceAnchor]
                        let dRect = proxy[destinationAnchor]
                        let animateView = info.animateView
                        
                        let size = CGSize(width: animateView ? dRect.size.width : sRect.size.width,
                                          height: animateView ?  dRect.size.height : sRect.size.height)
                        
                        let offset = CGSize(width: animateView ? dRect.maxX : sRect.maxX,
                                          height: animateView ?  dRect.maxY : sRect.maxY)
                        
                        layerView.frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: animateView ? info.dCornerRadius: info.sCornerRadius))
                            .offset(offset)
                            .transition(.identity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        
                        
                    }
                })
                .customOnChange(value: info.animateView) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                        if !newValue {
                            // resetting all data once the view goes back to it's source state
                            info.isActive = false
                            info.layerView = nil
                            info.sourceAnchor = nil
                            info.destinationAnchor = nil
                            info.sCornerRadius = 0
                            info.dCornerRadius = 0
                            info.completion(false)
                        }else {
                            info.hideView = true
                            info.completion(true)
                        }
                    }
                }
            }
        })
    }
}

fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {return nil}
        return rootViewController?.view == view ? nil : view
    }
}


struct SourceView<Content: View> : View {
    let id: String
    @ViewBuilder var content: Content
    @EnvironmentObject private var viewModel: HeroViewModel
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self,
                              value: .bounds,
                              transform: { anchor in
                if let index, viewModel.info[index].isActive {
                    return [id: anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index, viewModel.info[index].isActive, viewModel.info[index].sourceAnchor == nil {
                    viewModel.info[index].sourceAnchor = value[id]
                }
            })
    }
    
    var index: Int? {
        if let index = viewModel.info.firstIndex(where: {$0.infoID == id}) {
            return index
        }
        return nil
    }
    
    var opacity: CGFloat {
        if let index {
            return viewModel.info[index].isActive ? 0 : 1
        }
        return 1
    }
    
}

struct DestinationView<Content: View> : View {
    var id: String
    @ViewBuilder var content: Content
    @EnvironmentObject private var viewModel: HeroViewModel
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self,
                              value: .bounds,
                              transform: { anchor in
                if let index, viewModel.info[index].isActive {
                    return ["\(id)DESTINATION": anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index, viewModel.info[index].isActive {
                    viewModel.info[index].destinationAnchor = value["\(id)DESTINATION"]
                }
            })
    }
    var index: Int? {
        if let index = viewModel.info.firstIndex(where: {$0.infoID == id}) {
            return index
        }
        return nil
    }
    var opacity: CGFloat {
        if let index {
            return viewModel.info[index].isActive ? (viewModel.info[index].hideView ? 1 : 0) : 0
        }
        return 1
    }
}

extension View {
    @ViewBuilder
    func heroLayer<Content: View>(
        id:String,
        animate: Binding<Bool>,
        sourceCornerRadius: CGFloat = 0,
        destinationCornerRadius: CGFloat = 0 ,
        @ViewBuilder content: @escaping() -> Content,
        completion: @escaping (Bool) -> Void
    ) -> some View {
        self
            .modifier(HeroLayerViewModifier(id: id, animate: animate, sourceCornerRadius: sourceCornerRadius, destinationCornerRadius: destinationCornerRadius, layer: content, completion: completion))
    }
}

fileprivate struct HeroLayerViewModifier<Layer: View>: ViewModifier {
    let id: String
    @Binding var animate: Bool
    var sourceCornerRadius: CGFloat
    var destinationCornerRadius: CGFloat
    @ViewBuilder var layer: Layer
    var completion: (Bool) -> Void
    
    @EnvironmentObject private var viewModel: HeroViewModel
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                if viewModel.info.contains(where: {$0.infoID == id}) {
                    viewModel.info.append(.init(id: id))
                }
            })
            .customOnChange(value: animate) { newValue in
                if let index = viewModel.info.firstIndex(where: {$0.infoID == id}) {
                    // setting up all the necessary properties for the animation
                    viewModel.info[index].isActive = true
                    viewModel.info[index].layerView = AnyView(layer)
                    viewModel.info[index].sCornerRadius = sourceCornerRadius
                    viewModel.info[index].dCornerRadius = destinationCornerRadius
                    viewModel.info[index].completion = completion
                    
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                viewModel.info[index].animateView = true
                            }
                        }
                    }else {
                        viewModel.info[index].hideView = false  
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            viewModel.info[index].animateView = false
                        }
                    }
                    
                }
            }
    }
}



// EnvirtationObject
fileprivate class HeroViewModel: ObservableObject {
    @Published var info:[HeroInfo] = []
    
}
// Indiviudal hero animation view info
fileprivate struct HeroInfo: Identifiable {
    private(set) var id: UUID = .init()
    private(set) var infoID: String
    var isActive: Bool = false
    var layerView: AnyView?
    var animateView: Bool = false
    var hideView: Bool = false
    var sourceAnchor: Anchor<CGRect>?
    var destinationAnchor: Anchor<CGRect>?
    var sCornerRadius: CGFloat = 0
    var dCornerRadius: CGFloat = 0
    var completion:(Bool) -> Void = {_ in }
    init(id: String) {
        self.infoID = id
    }
}


fileprivate struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) {
            $1
        }
    }
}




extension View {
    @ViewBuilder
    func customOnChange<Value: Equatable>(value: Value, completion:@escaping (Value) -> Void) -> some View {
        if #available(iOS 17, *) {
            self.onChange(of: value) { oldValue, newValue in
                completion(newValue)
            }
        }else {
            self.onChange(of: value, perform: { value in
                completion(value)
            })
        }
    }
}



#Preview {
    ContentView()
}
