//
//  TagTextField.swift
//  A_36_Tag TextField
//
//  Created by Kan Tao on 2024/1/2.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id = UUID()
    var value: String
    var isInitial: Bool = false
}



struct TagTextField: View {
    @Binding var tags:[Tag]
    var body: some View {
        HStack {
            ForEach($tags) { $tag in
                TagView(tag: $tag, allTags: $tags)
                    .onChange(of: tag.value) { oldValue, newValue in
                        if newValue.last == " " {
                            tag.value.removeLast()
                            //  tags.last?.value.isEmpty ?? false
                            if !tag.value.isEmpty {
                                tags.append(.init(value: ""))
                            }
                            
                        }
                    }
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .background(.bar, in: .rect(cornerRadius: 12))
        .onAppear {
            // initializing tag view
            if tags.isEmpty {
                tags.append(Tag.init(value: "", isInitial: true))
            }
        }
    }
}

fileprivate struct TagView: View {
    @Binding var tag:Tag
    @Binding var allTags:[Tag]
    @FocusState private var isFocused: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TextField("Tag", text: $tag.value)
            .focused($isFocused)
            .padding(.horizontal, isFocused || tag.value.isEmpty ? 0 : 10)
            .padding(.vertical, 10)
            .background((colorScheme == .dark ? Color.black : Color.white).opacity(isFocused || tag.value.isEmpty ? 0 : 1), in: .rect(cornerRadius: 5))
            .disabled(tag.isInitial)
            .onChange(of: allTags, initial: true) {oldValue, newValue in
                if newValue.last?.id == tag.id && !(newValue.last?.isInitial ?? false) && !isFocused {
                    isFocused = true
                }
            }
            .overlay {
                if tag.isInitial {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .onTapGesture {
                            tag.isInitial = false
                            isFocused = true
                        }
                }
            }
    }
}


#Preview {
    ContentView()
}
