//
//  ContentView.swift
//  A_87_JSON Parsing With Pagination iOS 17 Xcode 15
//
//  Created by Kan Tao on 2024/10/10.
//

import SwiftUI

struct ContentView: View {
    @State private var photos:[Photo] = []
    @State private var page: Int = 1
    @State private var lastFetchedPage: Int = 1
    @State private var isLoading: Bool = false
    @State private var maxPage: Int = 5
    // pagnation properties
    @State private var activePhotoID: String?
    @State private var lastPhotoID: String?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10, content: {
                    ForEach(photos) { photo in
                        PhotoCardItem(photo: photo)
                    }
                })
                .overlay(alignment: .bottom, content: {
                    if isLoading {
                        ProgressView()
                            .offset(y: 30)
                    }
                })
                .padding(15)
                .padding(.bottom, 15)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $activePhotoID, anchor: .bottom)
            .navigationTitle("JSON Persing")
            .onChange(of: activePhotoID, { oldValue, newValue in
                if newValue == lastPhotoID, !isLoading, page != maxPage {
                    page += 1
                    fetchPhotos()
                }
            })
            .onAppear(perform: {
                if photos.isEmpty {
                    fetchPhotos()
                }
            })
        }
    }
    
    
    private func fetchPhotos() {
        Task {
            do {
                if let url = URL.init(string: "https://picsum.photos/v2/list?page=\(page)&limit=10") {
                    isLoading = true
                    let session = URLSession(configuration: .default)
                    let jasonData = try await session.data(from: url).0
                    let photos = try JSONDecoder().decode([Photo].self, from: jasonData)
                    // updating ui in main theard
                    await MainActor.run {
                        if photos.isEmpty {
                            page = lastFetchedPage
                            maxPage = lastFetchedPage
                        } else {
                            self.photos.append(contentsOf: photos)
                            lastPhotoID = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

struct PhotoCardItem: View {
    var photo: Photo
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                AsyncImage(url: photo.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                }
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 10))
            })
            .frame(height: 120)
            
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
        })
    }
}



#Preview {
    ContentView()
}



struct Photo: Identifiable , Codable, Hashable {
    var id: String
    var author: String
    var url: String
    
    private var downloadURLString: String
    
    enum CodingKeys:String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }
    
    var downloadURL: URL? {
        return URL.init(string: downloadURLString)
    }
    
    var imageURL: URL? {
        return URL.init(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}
