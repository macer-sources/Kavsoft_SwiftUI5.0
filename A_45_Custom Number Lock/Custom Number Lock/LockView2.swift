//
//  LockView2.swift
//  Custom Number Lock
//
//  Created by Kan Tao on 2024/3/21.
//

import SwiftUI
import LocalAuthentication



extension SupportLockView {
    enum LockType: String {
        case biometric = "Bio Metric Auth" // 生物识别
        case number = "Custom Number Lock"  // 数字键盘
        case both = "First preference will be biometric, and if it's not available, it will go for number lock" //  两者都有
    }
}


struct LockConfig {
    var lockPin: String         // 密码
    var isEnabled: Bool         // 是否启用功能
    var lockWhenAppGoesBackground: Bool = false     // 进入后台锁定
    var safeMode: Bool = false                      // 是否开启安全模式
    var interval: TimeInterval = 0                  // 进入后台马上锁死
    var maxTryCount: Int = 1                    // 最大尝试次数
}



struct SupportLockView<Content: View>: View {
    var lockType: LockType      // 模式
    var config: LockConfig
    
    
    @ViewBuilder var content: Content           // 正常的
    @ViewBuilder var safeContent: Content       // 安全界面
    
    
    var forgotPin:() -> Void = {}
    
    
    @State private var pin: String = ""         // 当前输入的密码
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false //是否已经解锁
    
    @State private var noBiometricAccess: Bool = false
    private let context = LAContext()
    @Environment(\.scenePhase) private var scenePhase
    
    
    @State private var currentTryCount: Int = 0     //当前尝试次数
    lazy var timer = Timer.publish(every: config.interval, on: .main, in: .common).autoconnect()
    @State private var begingBiotricAccess = false
    
    var body: some View {
        let _ = Self._printChanges()
        GeometryReader { proxy in
            let size = proxy.size

            if config.isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentication in settings to unlock the view.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            }else {
                                // Bio mETRIC/ Pin Unlock
                                VStack(spacing: 12, content: {
                                    VStack(spacing: 6, content: {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    })
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 100)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                })
                            }
                        }
                    }else {
                        // Custom number pad to type app lock pin
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }else {
                if !config.isEnabled {
                    content.frame(width: size.width, height: size.height)
                }else {
                    if config.safeMode , currentTryCount >= config.maxTryCount {
                        safeContent.frame(width: size.width, height: size.height)
                    }else {
                        content.frame(width: size.width, height: size.height)
                    }
                }
            }
        }
        .onChange(of: config.isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        // Locking when app goes background
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue != .active && config.lockWhenAppGoesBackground, !begingBiotricAccess {
                isUnlocked = false
                pin = ""
                currentTryCount = 0
            }
        }
    }
}


extension SupportLockView {
    @ViewBuilder
    func NumberPadPinView() -> some View {
        VStack(spacing: 15, content: {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    // Back Button only for both lock type
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            // Adding Wiggling Animation for Wrong Password With Keyframe Animator
            
            HStack(spacing: 10, content: {
                ForEach(0..<4, id:\.self) {index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                    // showing pin at each box with the help of index
                        .overlay {
                            // safe check
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            })
            .padding(.top, 15)
            .keyframeAnimator(initialValue: .zero, trigger: animateField, content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forget Pin?") {
                    forgotPin()
                }
                .foregroundStyle(.white)
                .offset(y: 40)
            })
            .frame(maxHeight: .infinity)
            
            CustomKeyboard()
        })
        .padding()
        .environment(\.colorScheme, .dark)
    }
}
 


extension SupportLockView {
    private func unlockView() {
        // checking and unlocking view
        Task {
            if isBiometricAvailable &&  lockType != .number {
                // requesting biometric unlock
                begingBiotricAccess = true
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View"), result {
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                        currentTryCount = 0
                        debugPrint("=======")
                    }
                }else {
                    debugPrint("===========解锁失败:\(currentTryCount)")
                    currentTryCount += 1
                    if config.safeMode,currentTryCount >= config.maxTryCount {
                        debugPrint("===========进入安全模式")
                        isUnlocked = true
                    }
                }
            }
            
            // No bio metric permission || lock type must be set as keypad
            // updating biometric status
            noBiometricAccess = !isBiometricAvailable
            begingBiotricAccess = false
        }
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}


extension SupportLockView {
    @ViewBuilder
    private func CustomKeyboard() -> some View {
        GeometryReader { proxy in
            LazyVGrid(columns: Array.init(repeating: GridItem(), count: 3), content: {
                ForEach(1...9, id:\.self) { number in
                    Button(action: {
                        if pin.count < 4 {
                            pin.append("\(number)")
                        }
                    }, label: {
                        Text("\(number)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .tint(.white)
                }
                
                Button(action: {
                    if !pin.isEmpty {
                        pin.removeLast()
                    }
                }, label: {
                    Image(systemName: "delete.backward")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .contentShape(.rect)
                })
                .tint(.white)
                
                Button(action: {
                    if pin.count < 4 {
                        pin.append("0")
                    }
                }, label: {
                    Text("0")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .contentShape(.rect)
                })
                .tint(.white)
            })
            .frame(maxHeight: .infinity)
            .frame(alignment: .bottom)
        }
        .onChange(of: pin) { oldValue, newValue in
            if newValue.count == 4 {
                // 开始验证密码正确性
                if config.lockPin == pin {
                    print("Unlock")
                    withAnimation(.snappy,completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        // clearing pin
                        pin = ""
                        noBiometricAccess = !isBiometricAvailable
                        currentTryCount = 0
                    }

                }else {
                    print("lock")
                    pin = ""
                    animateField.toggle()
                    currentTryCount += 1
                    if config.safeMode,currentTryCount >= config.maxTryCount {
                        isUnlocked = true
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
