//
//  ContentView.swift
//  Synthesizer Style Panels
//
//  Created by Kan Tao on 2023/12/30.
//

import SwiftUI
//https://www.youtube.com/watch?v=-bQ9nPf9KxE
//https://github.com/BeauNouvelle?tab=repositories
struct ContentView: View {
    @StateObject var model = WindowModel()
    @StateObject var drawingManager = DrawingManager()
    
    var body: some View {
        ZStack(content: {
            ForEach(model.panels) { panel in
                PanelView(panel: panel, windowModel: model, drawingManager: drawingManager)
                    .frame(width: 200, height: 100)
            }
            
            ForEach(model.cables) { cable in
                Path { path in
                    path.move(to: cable.startSocket.position)
                    path.addCurve(to: cable.endSocket.position,
                                  control1: cable.startSocket.position.applying(CGAffineTransform(translationX: 0, y: 100)),
                                  control2: cable.endSocket.position.applying(CGAffineTransform.init(translationX: 0, y: 100)))
                }
                .strokedPath(.init(lineWidth: 4, lineCap: .round, dash: [5], dashPhase: 10))
            }
            if drawingManager.isDrawing {
                Path {path in
                    path.move(to: drawingManager.activePathStart)
                    path.addCurve(to: drawingManager.cursorPosition,
                                  control1: drawingManager.activePathStart.applying(CGAffineTransform(translationX: 0, y: 40)),
                                  control2: drawingManager.cursorPosition.applying(CGAffineTransform.init(translationX: 0, y: 40)))
                }
                .strokedPath(.init(lineWidth: 4, lineCap: .round, dash: [5], dashPhase: 10))
                .stroke(Color.primary)
            }
            
        })
        
        .toolbar(content: {
            Button(action: {
                model.panels.append(Panel())
            }, label: {
                Text("New Panel")
            })
        })
        .coordinateSpace(name: "Canvas")
    }
}

#Preview {
    ContentView()
}



class DrawingManager: ObservableObject {
    @Published var activePathStart: CGPoint = .zero
    @Published var cursorPosition: CGPoint = .zero
   @Published var isDrawing: Bool = false
}



enum PatreonPals: String {
    case alexYaney = "Alex Yaney"
    case stacey = "Stacey"
}

struct PanelView: View {
    let panel: Panel
    var windowModel: WindowModel
    @State private var location: CGPoint = .init(x: 50, y: 50)
    @GestureState private var startLocation: CGPoint?
    var drawingManager: DrawingManager
    
    
    var body: some View {
        VStack(content: {
            Text("Panel")
            HStack(spacing: 20,content: {
                ForEach(panel.sockets) { socket in
                    GeometryReader(content: { geometry in
                        SocketView()
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .named("Panel"))
                                    .onChanged({ gesture in
                                        drawingManager.isDrawing = true
                                        drawingManager.activePathStart = socket.position
                                        drawingManager.cursorPosition = gesture.location
                                    })
                                    .onEnded({ gesture in
                                        let gestureRect = CGRect.init(x: gesture.location.x - 15,
                                                                      y: gesture.location.y - 15,
                                                                      width: 30,
                                                                      height: 30)
                                        for endSocket in windowModel.panels.flatMap({$0.sockets}) {
                                            if gestureRect.contains(endSocket.position) {
                                                windowModel.cables.append(Cable.init(startSocket: socket, endSocket: endSocket))
                                                break
                                            }
                                        }
                                        drawingManager.isDrawing = false
                                    })
                            )
                            .onChange(of: geometry.frame(in: .named("Panel")).origin) { oldValue, newValue in
                                socket.position = CGPoint.init(x: newValue.x + 15, y: newValue.y + 15)
                                windowModel.cables = windowModel.cables
                            }
                            .onAppear {
                                socket.position = CGPoint.init(x: geometry.frame(in: .named("Panel")).minX  , y: geometry.frame(in: .named("Panel")).midY)
                            }
                    })
                    .frame(width: 30, height: 30)

                }
            })
            .padding(10)
        })
        .background(.cyan)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10) )
        .position(location)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    var newLocation = startLocation ?? location
                    newLocation.x += gesture.translation.width
                    newLocation.y += gesture.translation.height
                    self.location = newLocation
                    panel.position = newLocation
                })
                .updating($startLocation, body: { value, startLocation, transaction in
                    startLocation = startLocation ?? location
                })
            
        )
        .coordinateSpace(name: "Panel")
    }
}


struct SocketView: View {
    var body: some View {
        Circle()
            .stroke(style: .init(lineWidth: 4))
            .background(Circle().fill(.black))
            .frame(width: 30, height: 30)
    }
}
