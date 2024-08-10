//
//  ContentView.swift
//  A_24_Animated Tags View  Layout API
//
//  Created by Kan Tao on 2024/7/27.
//

import SwiftUI

struct ContentView: View {
    @State private var tags:[String] = [
        "SwiftUI",
        "Layout API",
        "Tags View",
        "TagView",
        "Matched",
        "Geometry Effect",
        "Dynamic Grid",
        "SwiftUI Custom Grid",
        "Xcode 15",
        "iOS 17",
        " Swift"
    ]
    // selection
    @State private var selectedTags:[String] = []
    
    // adding matched geometry effert
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(selectedTags,id:\.self) { tag in
                        TagView(tag, .pink, "checkmark")
                            .matchedTransitionSource(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.removeAll(where: {$0 == tag})
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.vertical, 15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .overlay(content: {
                if selectedTags.isEmpty {
                    Text("Select More than 3 Tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .background(.white)
            .zIndex(1)
            
            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 10) {
                    ForEach(tags.filter({!selectedTags.contains($0)}), id:\.self) { tag in
                        TagView(tag, .blue, "plus")
                            .matchedTransitionSource(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation {
                                    selectedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding()
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .background(.black.opacity(0.05))
            // 这个层级必须最低，否则滚动会覆盖其他view
            .zIndex(0)
            ZStack {
                Button {
                    
                } label: {
                    Text("Contine")
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.pink.gradient)
                        }
                }
                .disabled(selectedTags.count < 3)
                .opacity(selectedTags.count < 3 ? 0.5 : 1)
                .padding()
            }
            .background(.white)
            .zIndex(2)
        }
        .preferredColorScheme(.light)
    }
    
    
    @ViewBuilder
    private func TagView(_ tag: String, _ color: Color, _ icon: String) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)
            
            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundColor(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(color.gradient)
        }
    }
}

#Preview {
    ContentView()
}





struct TagLayout: Layout {
    // layout properties
    var alignment: Alignment = .center
    // both horizontal & vertical
    var spacing: CGFloat = 10
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        
        let maxWidth = proposal.width ?? 0
        let rows = generateRows(maxWidth, proposal, subviews)
        
        var height:CGFloat = 0
        
        
        for (index, row) in rows.enumerated() {
            // finding max height in each row and adding it to the view's total height
            if index == (rows.count - 1) {
                // since there is no spacing needed for the last item
                height += row.maxHeight(proposal)
            }else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        return  .init(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // placing views
        var origin  = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        for row in rows {
            // chaning origin x based on alignments
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    // no spacing
                    return partialResult + width
                }
                // with spacing
                return partialResult + width + spacing
            })
            
            let center = (trailing + leading) / 2
            
            // resetting origin x to zero for each row
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                // updating origin x
                origin.x += (viewSize.width + spacing)
            }
            
            // updating origin y
            origin.y += (row.maxHeight(proposal) + spacing)
        }
        
    }
    
    // generating rows based on available size
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews:Subviews) -> [[LayoutSubviews.Element]] {
        var row:[LayoutSubviews.Element] = []
        var rows:[[LayoutSubviews.Element]] = []
        
        // origin
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                // resetting x origin since it needs to start from left to right
                origin.x = 0
                row.append(view)
                // updating origin x
                origin.x += (viewSize.width + spacing)
            }else {
                // adding item same row
                row.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        
        // checking for any exhaust row
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        return rows
    }
    
}


extension [LayoutSubviews.Element] {
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}
