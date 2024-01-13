//
//  Home.swift
//  A_50_Building Complex Scroll Animations
//
//  Created by Kan Tao on 2024/1/13.
//

import SwiftUI

struct Home: View {
    var safeArea: EdgeInsets
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0, content: {
                
                
                VStack(spacing: 15, content: {
                    ForEach(1...15, id:\.self) { _ in
                        CardView()
                    }
                })
                .padding(15)
            })
        }
        .scrollIndicators(.hidden)
    }
}


extension Home {
    @ViewBuilder
    func CardView() -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.blue.gradient)
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12, content: {
                    Circle()
                        .frame(width: 40, height: 40, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 100, height: 5)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                        
                    })
                })
                .foregroundStyle(.white.opacity(0.25))
                .padding(.horizontal,15)
            }
            
    }
}







#Preview {
    ContentView()
}
