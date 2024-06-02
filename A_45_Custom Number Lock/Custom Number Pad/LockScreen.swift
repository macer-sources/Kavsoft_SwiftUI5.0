//
//  LockView.swift
//  Custom Number Pad
//
//  Created by Kan Tao on 2024/3/23.
//

import SwiftUI

struct LockScreen: View {
    @State private var password = ""
    @AppStorage("lock_password") var key = "5654"
    @Binding var unLock: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 0)
                Menu {
                    Label("Help", image: "info.circle.fill")
                        .onTapGesture {
                            debugPrint("Help")
                        }
                    Label("Reset Password", image: "key.fill")
                        .onTapGesture {
                            debugPrint("Reset Password")
                        }
                } label: {
                    Image(systemName: "menucard")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                }

            }
            .padding(.leading)
            
            Image("Logo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 20)
            
            Text("Enter Pin to Unlock")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top, 20)
            
            PasswordTextFieldView()
            
            Spacer()
            
            KeyPadView()
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}


extension LockScreen {
    @ViewBuilder
    private func PasswordTextFieldView() -> some View {
        HStack(spacing: 22, content: {
            ForEach(0..<4, id:\.self) { index in
                PasswordView(index: index, password: $password)
            }
        })
        .padding(.top, 30)
    }
}


extension LockScreen {
    @ViewBuilder
    private func KeyPadView() -> some View {
        LazyVGrid(columns: Array.init(repeating: GridItem(.flexible()), count: 3), spacing: 15, content: {
            ForEach(1...9, id: \.self) {index in
                PasswordButton(value: "\(index)", password: $password, key: $key, unLock: $unLock)
            }
            
            PasswordButton(value: "delete.fill", password: $password, key: $key, unLock: $unLock)
            PasswordButton(value: "0", password: $password, key: $key, unLock: $unLock)
        })
        .padding(.bottom)
    }
}

struct PasswordView: View {
    var index: Int
    @Binding var password: String
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 30, height: 30)
            // checking whether it is typed
            if password.count > index {
                Circle()
                    .fill(.white)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct PasswordButton: View {
    var value: String
    @Binding var password: String
    @Binding var key: String
    @Binding var unLock: Bool
    var body: some View {
        Button(action: setPassword, label: {
            VStack {
                if value.count > 1 {
                    // Image
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }else {
                    Text(value)
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        })
    }
    
    private func setPassword() {
        withAnimation {
            //checking if backspace pressed
            if value.count > 1 {
                if password.count != 0 {
                    password.removeLast()
                }
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if password.count != 4 {
                        password.append(value)
                        if password.count == 4 {
                            if password == key {
                                unLock = true
                            }else {
                                password.removeAll()
                            }
                        }
                    }
                }
            }
        }
    }
    
}
