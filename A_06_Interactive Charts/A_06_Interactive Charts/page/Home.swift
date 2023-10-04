//
//  Home.swift
//  A_06_Interactive Charts
//
//  Created by Kan Tao on 2023/10/4.
//

import SwiftUI
import Charts

enum GraphType: String, CaseIterable {
    case bar = "bar Chart"
    case pie = "pie Chart"
    case donut = "donut Chart"
}



struct Home: View {
    @State private var graphType: GraphType = .donut
    
    
    var body: some View {
        VStack(content: {
            // Segment Picker
            Picker("", selection: $graphType) {
                ForEach(GraphType.allCases, id:\.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            
            ChartView(graphType: $graphType)
            
            Spacer(minLength: 0)
        })
        .padding()
    }
}


struct ChartView : View {
    @Binding var graphType: GraphType
    var body: some View {
        Chart {
            ForEach(appDownloads) {download in
                if graphType == .bar{
                    BarMark(x: .value("Month", download.month),
                            y:.value("Downloads", download.downloads))
                    .cornerRadius(8)
                    .foregroundStyle(by: .value("Month", download.month))
                }else {
                    // new API
                    // Pie Donut Char
                    SectorMark(angle: 
                            .value("Downloads", download.downloads),
                               innerRadius: .ratio(graphType == .donut ? 0.6 : 0),
                               angularInset: graphType == .donut ? 4 : 1)
                        .cornerRadius(8)
                        .foregroundStyle(by: .value("Month", download.month))
                    
                }
            }
        }
        .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
        .frame(height: 300)
        .padding(.top, 15)
        // adding animation
        .animation(.snappy, value: graphType)
    }
}






#Preview {
    ContentView()
}
