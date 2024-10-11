//
//  ShareViewController.swift
//  Share
//
//  Created by Kan Tao on 2024/10/11.
//

import UIKit
import Social
import SwiftUI
import SwiftData
// https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1
class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        
        if let itemProviders = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(itemProviders:itemProviders, extensionContext: extensionContext))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
    }

}


fileprivate struct ShareView: View {
    var itemProviders:[NSItemProvider]
    var extensionContext: NSExtensionContext?
    @State private var items:[ImageItem] = []
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            VStack(spacing: 15, content: {
                Text("Add To Favourites")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .tint(.red)
                    }
                    .padding(.bottom, 10)
                
                ScrollView(.vertical) {
                    LazyHStack(spacing: 10, content: {
                        ForEach(items, id: \.id) { item in
                            Image(uiImage: item.previewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width - 30)
                        }
                    })
                    .padding(.horizontal, 15)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                .scrollIndicators(.hidden)
                
                Button(action: {saveItems()}, label: {
                    Text("Save")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .contentShape(.rect)
                })
                
                Spacer(minLength: 0)
            })
            .padding(15)
            .onAppear(perform: {
                extractImems(size: size)
            })
        })

    }
    
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    // save to swift model
    private func saveItems() {
        do {
            let context = try ModelContext(.init(for: ImageItemData.self))
            for item in items {
                context.insert(ImageItemData(data: item.imageData))
            }
            try context.save()
            dismiss()
        }catch {
            print(error.localizedDescription)
            dismiss()
        }
    }
    
    // extracting image data and creating thumbnail preview images
    func extractImems(size: CGSize) {
        guard items.isEmpty else {return}
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProviders {
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let data, let image = UIImage(data: data), let thumbail = image.preparingThumbnail(of: .init(width: size.width, height: 300))  {
                        // ui must be update on main thread
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previewImage: thumbail))
                        }
                    }
                }
            }
        }
    }
    
    private struct ImageItem: Identifiable {
        let id = UUID()
        var imageData:Data
        var previewImage: UIImage
    }
}


