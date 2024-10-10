//
//  DockProgress.swift
//  A_71_SwiftUI Dock Progress Bar for macOS Xcode 15
//
//  Created by Kan Tao on 2024/10/10.
//

import Foundation
import SwiftUI

class DockProgress: ObservableObject {
    static let shared = DockProgress()
    
    @Published var progress: CGFloat = .zero {
        didSet {
            updateDock()
        }
    }
    @Published var tint: Color = .red {
        didSet {
            updateDock()
        }
    }
    @Published var type: ProgressType = .full {
        didSet {
            updateDock()
        }
    }
    @Published var isVisiable: Bool = false {
        didSet {
            updateDock()
        }
    }
    
    enum ProgressType: String, CaseIterable {
        case full
        case bottom
    }
    
    
    private func updateDock() {
        guard isVisiable else {
            NSApplication.shared.dockTile.contentView = nil
            NSApplication.shared.dockTile.display()
            return
        }
        
        guard let logo = NSApplication.shared.applicationIconImage else {return}
        let view = NSHostingView(rootView: CustomDockView(logo: logo, tint: tint, progress: progress, type: type))
        view.layer?.backgroundColor = .clear
        view.frame.size = logo.size
        
        NSApplication.shared.dockTile.contentView = view
        //regifresh
        NSApplication.shared.dockTile.display()
        
    }
}


fileprivate struct CustomDockView: View {
    var logo: NSImage
    var tint: Color
    var progress: CGFloat
    var type: DockProgress.ProgressType
    var body: some View {
        ZStack {
            
            Image(nsImage: logo)
                .scaledToFit()
            
            GeometryReader(content: { geometry in
                let size = geometry.size
                let campedProgress = max(min(progress, 1), 0)
               
                if type == .full {
                    RoundedRectangle(cornerRadius: size.width / 5)
                        .trim(from: 0 , to: campedProgress)
                        .stroke(tint, lineWidth: 6)
                        .rotationEffect(.init(degrees: -90))
                        
                } else {
                    VStack {
                        
                        Spacer()
                        
                        ZStack(alignment: .leading){
                            Capsule()
                                .fill(Color.primary.opacity(0.5))
                            Capsule()
                                .fill(tint)
                                .frame(width: campedProgress * size.width)
                        }
                        .frame(height: 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            })
            .padding(15)
            .frame(alignment: .bottom)
        }
    }
}
