//
//  SupportContentView.swift
//  Custom Number Lock
//
//  Created by Kan Tao on 2024/3/21.
//

import SwiftUI

struct SupportContentView: View {
    let config = LockConfig.init(lockPin: "1234",
                                 isEnabled: true,
                                 lockWhenAppGoesBackground: true,
                                 safeMode: true,
                                 interval: 30,      // 这个值还不确定，没有验证通过
                                 maxTryCount: 3
    )
    var body: some View {
        SupportLockView(lockType: .both, config: config) {
            ZStack {
                Rectangle()
                    .fill(.blue)
                Text("正确页面")
            }
        } safeContent: {
            ZStack {
                Rectangle()
                    .fill(.red)
                Text("错误页面")
            }
        }
    }
}


#Preview {
    SupportContentView()
}
