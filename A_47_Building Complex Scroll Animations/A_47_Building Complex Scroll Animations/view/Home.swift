//
//  Home.swift
//  A_47_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var allExpensed:[Expense] = []
    @Environment(\.colorScheme) private var colorScheme
    @State private var activeCard: UUID?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0, content: {
                VStack(alignment: .leading, spacing: 15, content: {
                    Text("Hello iJustine")
                        .font(.largeTitle.bold())
                        .frame(height: 45)
                        .padding(.horizontal, 15)
                    
                    // TODO: 以下这里是重点
                    GeometryReader(content: { geometry in
                        let rect = geometry.frame(in: .scrollView)
                        let minY = rect.minY.rounded()
//                        Text("\(rect.debugDescription)")
                        // Card View
            
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0, content: {
                                ForEach(cards, id:\.id) { card in
                                    ZStack {
                                        if minY == 75.0 {
                                            // not scrolled
                                            // showing all cards
                                            CardView(card)
                                        }else {
                                            // scrolled
                                            // showing only selected card
                                            if activeCard == card.id {
                                                CardView(card)
                                            }else {
                                                Rectangle()
                                                    .fill(.clear)
                                            }
                                        }
                                    }
                                    .containerRelativeFrame(.horizontal)
                                }
                            })
                            .scrollTargetLayout()
                        }
                        .scrollIndicators(.hidden)
                        .scrollPosition(id: $activeCard)
                        .scrollTargetBehavior(.paging)
                        .scrollClipDisabled()
                        .scrollDisabled(minY != 75.0)
                        
                    })
                    .frame(height: 125)
                })
                
                LazyVStack(spacing: 15, content: {
                    Menu {
                        
                    } label: {
                        HStack(spacing: 4, content: {
                            Text("Filter By")
                            Image(systemName: "chevron.down")
                        })
                        .font(.caption)
                        .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    ForEach(allExpensed) { expense in
                        ExpenseCardView(expense)
                    }
                })
                .padding(15)
                .mask({
                    RoundedRectangle(cornerRadius: 30)
                        .fill(colorScheme == .dark ? .black: .white)
                        .visualEffect {content, proxy in
                            content
                                .offset(y: backgroundLimitOffset(proxy))
                        }
                })
                .background {
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .scrollView)
                        let minY = min(rect.minY - 125, 0)
                        let progress = max(min(-minY / 25 , 1), 0)
                        
                        RoundedRectangle(cornerRadius: 30 * progress)
                            .fill(colorScheme == .dark ? .black: .white)
                            .overlay(alignment: .top, content: {
                                
                            })
                        // limiting background scroll below the header
                            .visualEffect {content, proxy in
                                content
                                    .offset(y: backgroundLimitOffset(proxy))
                            }
                    }
                }
                
                
            })
            .padding(.vertical, 15)
        }
        .scrollTargetBehavior(CustomScrollBehaviour())
        .scrollIndicators(.hidden)
        .onAppear(perform: {
            if activeCard == nil {
                activeCard = cards.first?.id
            }
            
        })
        .onChange(of: activeCard) { oldValue, newValue in
            withAnimation {
                allExpensed = expenses.shuffled()
            }
        }
    }
}

extension Home {
    @ViewBuilder
    func ExpenseCardView(_ expense: Expense) -> some View {
        HStack(spacing: 0, content: {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(expense.product)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            })
            
            Spacer()
            
            Text(expense.amountSpent)
                .fontWeight(.bold)
        })
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
    
    
    // background limit offset
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        return minY < 100 ? -minY + 100 : 0
    }
    
}


extension Home {
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader(content: { geometry in
            let rect = geometry.frame(in: .scrollView(axis: .vertical))
//            Text("\(rect.debugDescription)")
            let minY = rect.minY
            let topValue: CGFloat = 75.0
            
            // TODO: 计算
            let offset = min(minY - topValue, 0)
            let progress = max(min(-offset / topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            
            ZStack {
                Rectangle()
                    .fill(card.bgColor)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(card.bgColor)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: -50, y: -40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .scaleEffect(scale, anchor: .bottom)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Spacer()
                    Text("Current Balance")
                        .font(.callout)
                    
                    Text(card.balance)
                        .font(.title.bold())
                })
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .offset(y: progress * -25)
            }
            .offset(y: -offset)
            // moving til top value
            .offset(y: progress * -topValue)
            
        })
        .padding(.horizontal, 15)
        
    }
}




// custom scroll target hehaviour
// AKA scrollWillEndDragging in UIKit
struct CustomScrollBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 75 {
            target.rect = .zero
        }
    }
}


#Preview {
    ContentView()
}
