//
//  ContentView.swift
//  A_18_Prevent Screenshot
//
//  Created by Kan Tao on 2023/10/5.
//

import SwiftUI

// TODO: 这种方式不行
//ScreenshotPreventView {
//    NavigationStack {
//
//    }
//}

// TODO: 这种方式可以
//ScreenshotPreventView {
//    Image("")
//    Text("")
//}



struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ScreenshotPreventView {
                        GeometryReader(content: {
                            let size = $0.size
                            
                            Image(.image2)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(topLeadingRadius: 35, topTrailingRadius: 35))
                        })
                        .padding(15)
                    }
                    .navigationTitle("Image")
                } label: {
                    Text("Show Image")
                }
                
                NavigationLink {
                    List {
                        Section("API Key") {
                            ScreenshotPreventView {
                                Text("fdnakfndkankdan")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        Section("APNS Key") {
                            ScreenshotPreventView {
                                Text("fdnakfndkankdan")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }.navigationTitle("key's")
                } label: {
                    Text("Show Security Keys")
                }
            }
            .navigationTitle("My List")
        }
    }
}

#Preview {
    ContentView()
}
