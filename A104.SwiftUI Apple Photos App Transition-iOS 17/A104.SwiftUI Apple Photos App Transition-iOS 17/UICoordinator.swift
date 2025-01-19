//
//  UICoordinator.swift
//  A104.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/6.
//

import Foundation
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
    var detailIndicatorPosition: String?
    
    // gesture properties
    var offset: CGSize = .zero
    var dragProgress: CGFloat = 0
    
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }

        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    private func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = 0
        detailIndicatorPosition = nil
    }
    
    func didDetailPageChanged() {
        if let updateItem = items.first(where: {$0.id == detailScrollPosition}) {
            selectedItem = updateItem
            // updating indicator position
            withAnimation(.easeOut(duration: 0.1)) {
                detailIndicatorPosition = updateItem.id
            }
        }
    }
    func didDetailIndicatorPageChanged() {
        if let updateItem = items.first(where: {$0.id == detailIndicatorPosition}) {
            selectedItem = updateItem
            // updating detail paging view as well
            detailScrollPosition = updateItem.id
        }
    }
}
