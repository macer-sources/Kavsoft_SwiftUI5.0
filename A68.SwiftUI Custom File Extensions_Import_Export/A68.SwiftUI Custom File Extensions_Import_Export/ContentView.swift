//
//  ContentView.swift
//  A68.SwiftUI Custom File Extensions_Import_Export
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

import CryptoKit

struct ContentView: View {
    @State private var transactions:[TransactionModel] = []
    @State private var importTransaction:Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions, id:\.self) { trans in
                    HStack(spacing: 10, content: {
                        VStack(alignment: .leading, spacing: 6, content: {
                            Text(trans.title)
                            Text(trans.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.gray)
                        })
                        Spacer(minLength: 0)
                        
                        Text("$\(trans.amount)")
                            .font(.callout.bold())
                    })
                }
            }
            .navigationTitle("Transactions")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        transactions.append(.init())
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "square.and.arrow.down.fill") {
                        importTransaction.toggle()
                    }
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    // share link
                    ShareLink(item: Transactions(transactions: transactions), preview: SharePreview("", image: "square.and.arrow.up.fill"))
                }
            })
            .fileImporter(isPresented: $importTransaction, allowedContentTypes: [.trnExportType]) { result in
                switch result {
                case .success(let url):
                    do {
                        let encryptedData = try Data(contentsOf: url)
                        let decyptedData = try AES.GCM.open(.init(combined: encryptedData), using: .trnKey)
                        // decoding data
                        let decodedTransactions = try JSONDecoder().decode(Transactions.self, from: decyptedData)
                        
                        self.transactions = decodedTransactions.transactions
                        
                    } catch {
                        
                    }
                case .failure(let failure):
                    break
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
