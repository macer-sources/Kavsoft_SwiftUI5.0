//
//  ContentView.swift
//  A_92_Animating-Swift-Charts-Xcode-16
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var appDownloads:[Download] = sampleDownloads
    @State private var isAnimated: Bool = false
    
    @State private var trigger: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ChatViews()
                Spacer()
            }
            .padding()
            .background(.gray.opacity(0.12))
            .navigationTitle("Animated Charts")
            .onAppear(perform: {
                // step 4: 添加动画支持
                animateChart()
            })
            .onChange(of: trigger, initial: false) { oldValue, newValue in
                resetChartAnimate()
                animateChart()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Trigger") {
                        // adding extra dummy data
                        appDownloads.append(contentsOf: [
                            .init(date: .createDate(1, 2, 24), value: 4700),
                            .init(date: .createDate(1, 3, 24), value: 9700),
                            .init(date: .createDate(1, 4, 24), value: 1700),
                        ])
                        trigger.toggle()
                    }
                }
            })
        }
    }
}

extension ContentView {
    @ViewBuilder
    private func ChatViews() -> some View {
        Chart {
            ForEach(appDownloads) {download in
//                BarMark(x: .value("Month", download.month),
//                        // step 2: 使用属性参与图标绘制运算
//                        y: .value("Downloads", download.isAnimated ? download.value : 0))
//                LineMark(x: .value("Month", download.month),
//                        // step 2: 使用属性参与图标绘制运算
//                        y: .value("Downloads", download.isAnimated ? download.value : 0))
//                    .foregroundStyle(.red.gradient)
//                    .opacity(download.isAnimated ? 1 : 0)
                
                
                SectorMark(angle: .value("Downloads", download.isAnimated ? download.value : 0))
                    .foregroundStyle(by: .value("Month", download.month))
                .opacity(download.isAnimated ? 1 : 0)
            }
        }
        
        // Step 3:  对于 LineMark、BarMark 和 AreaMark，它是  我们必须声明 y 轴域范围，  否则，动画将无法正常工作。  （对于我的使用，我使用了 12,000 的粗略值，  但是你可以使用数组 max） 属性来获取  图表中的最大值）
        .chartYScale(domain: 0...12000)
        .frame(height: 250)
        .padding()
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    private func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        $appDownloads.enumerated().forEach { index, element in
            // （可选）您可以限制特定索引之后的动画。假设我们有大量数据，并且不想对所有元素进行动画处理，则可以将动画限制为特定数量的索引，例如 20。
            if index > 5 {
                element.wrappedValue.isAnimated = true
            } else {
                let delay = Double(index) * 0.05
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.snappy) {
                        element.wrappedValue.isAnimated = true
                    }
                }
            }
        }
        
    }
    
    private
    func resetChartAnimate() {
        $appDownloads.forEach { downlaod in
            downlaod.wrappedValue.isAnimated = false
        }
        isAnimated = false
    }
}


#Preview {
    ContentView()
}
