//
//  Login.swift
//  A_11_Glass Background Effect
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI

struct Login: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        VStack(content: {
            VStack(spacing: 12, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("UserName")
                        .font(.callout.bold())
                        .padding(.top, 15)
                    CustomTextField("iJustine", value: $username)
                    
                    Text("Password")
                        .font(.callout.bold())
                        .padding(.top, 15)
                    CustomTextField("******", value: $username)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.bg)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                            .padding(.top, 30)
                    })
                })
                
                // Other login options
                HStack(spacing: 12, content: {
                    Button(action: {}, label: {
                        Label("Email", systemImage: "envelope.fill")
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.2))
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Label("Apple", systemImage: "applelogo")
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(.white.opacity(0.2))
                            .clipShape(.rect(cornerRadius: 8, style: .continuous))
                    })
                })
                .foregroundStyle(.white)
                .padding(.top, 15)
                
            })
            .padding(.horizontal, 30)
            .padding(.top, 35)
            .padding(.bottom, 25)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.3), lineWidth: 1.5)
            }
            .shadow(color: .black.opacity(0.2), radius: 10)
            .padding(.horizontal, 40)
            .background {
                ZStack {
                    Circle()
                        .fill(.linearGradient(colors: [
                            .gradient1,
                            .gradient2
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .offset(x: -25, y: -55)
                    
                    Circle()
                        .fill(.linearGradient(colors: [
                            .gradient3,
                            .gradient4
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: 25, y: 55)
                    
                }
            }
            
        })
        .frame(maxWidth: 390)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.bg)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CustomTextField(_ hint: String, value: Binding<String>, isPassword: Bool = false) -> some View {
        Group(content: {
            if isPassword {
                SecureField(hint, text: value)
            }else {
                TextField(hint, text: value)
            }
        })
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(.white.opacity(0.12))
            .clipShape(.rect(cornerRadius: 8, style: .continuous))
    }
    
    
}

#Preview {
    ContentView()
}



struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters:Bool = false
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let layer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    layer.filters = []
                }else {
                    layer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}
