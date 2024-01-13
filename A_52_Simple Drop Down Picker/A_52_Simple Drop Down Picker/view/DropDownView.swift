//
//  DropDownView.swift
//  A_52_Simple Drop Down Picker
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct DropDownView: View {
    // customization properties
    var hint: String
    var options:[String]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 15
    
    @Binding var selection: String?
    
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex = 1000.0
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            VStack(spacing: 0, content: {
                
                if showOptions && anchor == .top {
                    OptionsView()
                }
                
                
                HStack(spacing: 0, content: {
                    Text(selection ?? hint)
                        .foregroundStyle(selection == nil ? .gray : .primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.gray)
                    // rotating icon
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                })
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(scheme == .dark ? .black : .white)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .zIndex(10)
                
                if showOptions && anchor == .bottom {
                    OptionsView()
                }
                
            })
            .clipped()
            // clips all interaction within it's bounds
            .contentShape(.rect)
            .background (
                (scheme == .dark ? Color.black : Color.white)
                    .shadow(.drop(color: .primary.opacity(0.15), radius: 4)),
                in: .rect(cornerRadius: cornerRadius)
            )
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
        })
        .frame(width: maxWidth, height: 50)
        .zIndex(zIndex)
    }
    
    
    // options View
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10, content: {
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0, content: {
                    Text(option)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .opacity(selection == option ? 1 : 0)
                })
                .foregroundStyle(selection == option ? Color.primary : .gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        // closeing drop down view
                        showOptions = false
                    }
                }
            }
        })
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        // adding transition
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
    
    // Drop down direction
    enum Anchor {
        case top
        case bottom
    }
}

#Preview {
    ContentView()
}
