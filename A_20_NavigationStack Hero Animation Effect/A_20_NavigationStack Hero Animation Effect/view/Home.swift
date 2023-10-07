//
//  Home.swift
//  A_20_NavigationStack Hero Animation Effect
//
//  Created by Kan Tao on 2023/10/7.
//

import SwiftUI

struct Home: View {
    var body: some View {
        List(profiles) { profile in
            HStack(spacing: 15, content: {
                Color.clear
                    .frame(width: 60, height: 60)
                    .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                        return [profile.id : anchor]
                    })
                
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(profile.name)
                        .fontWeight(.semibold)
                    Text(profile.lastMsg)
                        .font(.callout)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(profile.lastActive)
                    .font(.caption)
                    .foregroundStyle(.gray)
            })
        }
        .overlayPreferenceValue(MAnchorKey.self, { value in
            GeometryReader(content: { geometry in
                ForEach(profiles) { profile in
                    // fetching each profile image view using the profile id
                    if let anchor = value[profile.id] {
                        let rect = geometry[anchor]
                        ImageView(profile: profile, size: rect.size)
                            .offset(x: rect.minX, y: rect.minY)
                    }
                }
            })
        })
    }
}

struct ImageView: View {
    var profile: Profile
    var size: CGSize
    var body: some View {
        Image(profile.pic)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(.circle)
    }
}



#Preview {
    ContentView()
}
