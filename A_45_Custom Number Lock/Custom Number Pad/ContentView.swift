//
//  ContentView.swift
//  Custom Number Pad
//
//  Created by Kan Tao on 2024/3/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var unLocked = false
    var body: some View {
        if unLocked {
            VStack {
                Text("解锁成功")
            }
        }else {
            NavigationStack {
                ZStack {
                    // Lockscreen
                    LockScreen(unLock: $unLocked)
                        .preferredColorScheme(.dark)
                }
            }
        }
        
//        ZStack {
//            if unLocked {
//                VStack {
//                        Text("解锁成功")
//                    }
//            }else {
//                LockScreen(unLock: $unLocked)
//            }
//        }
//        .preferredColorScheme(unLocked ? .light : .dark)
    }
}

#Preview {
    ContentView()
}
