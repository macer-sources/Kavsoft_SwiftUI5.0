//
//  ViewModel.swift
//  Synthesizer Style Panels
//
//  Created by Kan Tao on 2023/12/30.
//

import SwiftUI


class WindowModel: ObservableObject {
   @Published var panels:[Panel] = []
   @Published var cables:[Cable] = []
    init() {
        self.panels = [.init()]
    }
}

// 节点
class Panel: Identifiable {
    var id = UUID()
    var position: CGPoint = .zero // 节点位置
    var sockets:[Socket] = [Socket(),Socket()] // 默认有两个⭕️
}

// 线
class Cable: Identifiable {
    var id = UUID()
    var startSocket: Socket
    var endSocket: Socket
    
    init(startSocket: Socket, endSocket: Socket) {
        self.startSocket = startSocket
        self.endSocket = endSocket
    }
}

// 节点上的⭕️
class Socket: Identifiable {
    var id = UUID()
    var position: CGPoint = .zero
}
