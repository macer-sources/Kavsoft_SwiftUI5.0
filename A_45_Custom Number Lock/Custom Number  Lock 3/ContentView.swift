//
//  ContentView.swift
//  Custom Number Lock
//
//  Created by Kan Tao on 2024/1/4.
//

import SwiftUI



struct ContentView: View {
    @State var lockStatus: LockStatus = .unLocked(mode: .Success)
    @AppStorage("support_Locked") var support_Lock: Bool = false
    var body: some View {
        if support_Lock {
            switch lockStatus {
            case .Locked:
                LockScreen(lockStatus: $lockStatus)
                    .preferredColorScheme(.dark)
            case .unLocked(let mode):
                switch mode {
                case .Fail:
                    _FailView()
                case .Success:
                    _SuccessView()
                }
            }
        }else {
            _SuccessView()
        }
    }
}

struct _SuccessView: View {
    @AppStorage("support_Locked") var support_Lock: Bool = false
    var body: some View {
        VStack {
            Text("解锁成功")
            Toggle(isOn: $support_Lock, label: {
                Text("是否开启Locked 支持")
            })
        }
    }
}


struct _FailView: View {
    var body: some View {
        VStack {
            Text("隐藏功能的")
        }
    }
}

#Preview {
    ContentView()
}
