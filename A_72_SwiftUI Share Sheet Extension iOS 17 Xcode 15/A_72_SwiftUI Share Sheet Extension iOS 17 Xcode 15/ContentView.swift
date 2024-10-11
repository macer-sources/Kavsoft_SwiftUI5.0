//
//  ContentView.swift
//  A_72_SwiftUI Share Sheet Extension iOS 17 Xcode 15
//
//  Created by Kan Tao on 2024/10/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var items:[ImageItemData]
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10, content: {
                    ForEach(items, id: \.self) { item in
                        CardView(item: item)
                            .frame(height: 250)
                    }
                })
                .padding(15)
            }
        }
    }
}

struct CardView: View {
    var item: ImageItemData
    @State private var previewImage: UIImage?
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            if let previewImage = previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            } else {
                ProgressView()
                    .frame(width: size.width, height: size.height)
                    .task {
                        generatePreviewImage(size)
                    }
            }
            
        })
    }
    
    private func generatePreviewImage(_ size: CGSize) {
        Task.detached(priority: .high) {
            let thumbnail = UIImage(data: item.data)?.preparingThumbnail(of: size)
            await MainActor.run {
                previewImage = thumbnail
            }
        }
    }
    
}


#Preview {
    ContentView()
}
