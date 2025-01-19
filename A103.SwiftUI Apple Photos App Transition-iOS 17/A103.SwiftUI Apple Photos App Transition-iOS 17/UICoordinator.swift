//
//  UICoordinator.swift
//  A103.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/2.
//

import SwiftUI

@Observable
class UICoordinator {
    var items:[Item] = sampleItems.compactMap({
        Item.init(title: $0.title, image: $0.image, previewImage: $0.image)
    })
    // animation properties
    var selectedItem: Item?
    var animateView: Bool = false
    var showDetailView: Bool = false
    
    
    // scroll position
    var detailScrollPosition: String?
    
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 0.25), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }

        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.25), completionCriteria: .removed) {
                animateView = false
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    private func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil 
    }
    
    func didDetailPageChanged() {
        if let updateItem = items.first(where: {$0.id == detailScrollPosition}) {
            selectedItem = updateItem
        }
    }
    
}
