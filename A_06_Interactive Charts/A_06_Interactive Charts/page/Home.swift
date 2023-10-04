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
    @State private var barSelection: String?
    
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
            
            if let highestDownloads = appDownloads.max(by: {$0.downloads > $1.downloads}) {
                CharPopOverView(downloads: highestDownloads.downloads, month: highestDownloads.month , isTitleView: true)
                    .padding(.vertical)
                    .opacity(barSelection == nil ? 1 : 0)
            }
            
            ChartView(graphType: $graphType, barSelection: $barSelection)
            
            Spacer(minLength: 0)
        })
        .padding()
    }
}


struct ChartView : View {
    @Binding var graphType: GraphType
    // chart Selection
    @Binding var barSelection: String?
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
            
            if let barSelection {
                RuleMark(x: .value("Month", barSelection))
                    .foregroundStyle(.gray.opacity(0.35))
                    .zIndex(-10)
                    .offset(yStart: -10)
                    // popover 实现
                    .annotation(position: .top, spacing: -100,
                                overflowResolution: .init(x: .disabled, y: .disabled)) {
                        if let downloads = appDownloads.findDownloads(barSelection) {
                            CharPopOverView(downloads: downloads, month: barSelection)
                        }
                    }
            }
        }
        .chartLegend(position: .bottom, alignment: graphType == .bar ? .leading : .center, spacing: 25)
        .frame(height: 300)
        .padding(.top, 15)
        // adding animation
        .animation(.snappy, value: graphType)
        .chartXSelection(value: $barSelection)
    }
}


struct CharPopOverView: View {
    var downloads: Double
    var month: String
    var isTitleView: Bool = false
    var body: some View {
        VStack(alignment: .leading,spacing: 6, content: {
            Text("\(isTitleView ? "Highest" : "App") Downloads")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4, content: {
                Text(String.init(format: "%.0f", downloads))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(month)
                    .font(.title3)
                    .textScale(.secondary)
            })
        })
        .padding(isTitleView ? [.horizontal] : [.all])
        .background(Color.gray.opacity(isTitleView ? 0 : 0.8),in: .rect(cornerRadius: 8))
        .frame(maxWidth: .infinity, alignment: isTitleView ? .leading : .center)
    }
}






#Preview {
    ContentView()
}
