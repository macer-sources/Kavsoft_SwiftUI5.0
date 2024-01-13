//
//  ContentView.swift
//  A_41_Custom In-App Custom Notification's
//
//  Created by Kan Tao on 2024/1/12.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet, content: {
                    Button("Show Airdrp Notification") {
                        UIApplication.shared.inAppNotification {
                            HStack {
                                Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                VStack(alignment: .leading,spacing: 10, content: {
                                    Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                    Text("From iJustine")
                                        .textScale(.secondary)
                                        .foregroundColor(.gray)
                                })
                                .padding(.top, 20)
                                Spacer()
                            }
                            .padding(15)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.black)
                            }
                        }
                    }
                })
                
                
                Button("Show Notification") {
                    UIApplication.shared.inAppNotification {
                        HStack {
                            Image("avator_1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                            
                            VStack(alignment: .leading,spacing: 10, content: {
                                Text("iJustine")
                                    .font(.callout.bold())
                                    .foregroundColor(.white)
                                Text("Hello, this is iJustine")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            })
                            .padding(.top, 20)
                            Spacer()
                            
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                            })
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                            .tint(.white)
                        }
                        .padding(15)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.black)
                        }
                    }
                }
            }
            .navigationTitle("In App Notification's")
        }
    }
}

#Preview {
    ContentView()
}
