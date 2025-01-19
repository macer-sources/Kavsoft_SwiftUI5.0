//
//  DetailView.swift
//  A104.SwiftUI Apple Photos App Transition-iOS 17
//
//  Created by 10191280 on 2024/12/6.
//

import SwiftUI

struct DetailView: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        
        VStack(spacing: 0) {
            
            NavigationBar()
            
            GeometryReader {
                let size = $0.size

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(coordinator.items) { item in
                            ImageView(item,size: size)
                        }
                    }
                    .scrollTargetLayout()
                }
                // making it as a paging view
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(id: .init(get: {
                    return coordinator.detailScrollPosition
                }, set: {
                    coordinator.detailScrollPosition = $0
                }))
                .onChange(of: coordinator.detailScrollPosition, { oldValue, newValue in
                    coordinator.didDetailPageChanged()
                })
                .background {
                    if let selectedItem = coordinator.selectedItem {
                        Rectangle()
                            .fill(.clear)
                            .anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
                                return [selectedItem.id + "DEST": anchor]
                            }
                    }
                }
                .offset(coordinator.offset)
                
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: 10)
                    .contentShape(.rect)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                let translation = value.translation
                                coordinator.offset = translation
                                // progress for fading out the detail view
                                let heightProgress = max(min(translation.height / 200, 1), 0)
                                coordinator.dragProgress = heightProgress
                                
                            })
                            .onEnded({ value in
                                let translation = value.translation
                                let velocity = value.velocity
//                                let width = translation.width + velocity.width / 5// 也可以使用这个值，这里使用的是height
                                let height = translation.height + (velocity.width / 5)
                                
                                if height > (size.height * 0.5) {
                                    // close view
                                    coordinator.toggleView(show: false)
                                } else {
                                    // reset to origin
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        coordinator.offset = .zero
                                        coordinator.dragProgress = 0
                                    }
                                }
                            })
                        
                    )
                
            }
            .opacity(coordinator.showDetailView ? 1 : 0)
            
            BottomIndicatorView()
                .offset(y: coordinator.showDetailView ? (120 * coordinator.dragProgress) : 120)
                .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
        }
        
        .onAppear {
            coordinator.toggleView(show: true)
        }
    }
}

extension DetailView {
    @ViewBuilder
    private func ImageView(_ item: Item,size: CGSize)-> some View {
        if let image = item.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(.rect)
            
            
        }
    }
}


extension DetailView {
    // custom navigation bar
    @ViewBuilder
    private func NavigationBar() -> some View {
        HStack {
            Button(action: {coordinator.toggleView(show: false)}) {
                HStack(spacing: 2) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Back")
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .padding(10)
                    .background(.bar, in: .circle)
            }

        }
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: coordinator.showDetailView ? (-120 * coordinator.dragProgress) : -120)
        .animation(.easeInOut(duration: 0.15), value: coordinator.showDetailView)
    }
}


extension DetailView {
    @ViewBuilder
    private func BottomIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    ForEach(coordinator.items) { item in
                        // preview image view
                        if let image = item.previewImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 10))
                                .scaleEffect(0.97)
                        }
                    }
                }
                .padding(.vertical, 10)
                .scrollTargetLayout()
            }
            // 50  - item size inside scrollview
            .safeAreaPadding(.horizontal, (size.width - 50) / 2)
            .overlay(content: {
                // active indicator icon
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .allowsHitTesting(false)
                
            })
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                return coordinator.detailIndicatorPosition
            }, set: {
                coordinator.detailIndicatorPosition = $0
            }))
            .scrollIndicators(.hidden)
            .onChange(of: coordinator.detailIndicatorPosition) { oldValue, newValue in
                coordinator.didDetailIndicatorPageChanged()
            }
        }

        .frame(height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}


#Preview {
    ContentView()
}
