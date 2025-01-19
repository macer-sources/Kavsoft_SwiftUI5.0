//
//  models.swift
//  A68.SwiftUI Custom File Extensions_Import_Export
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

import UniformTypeIdentifiers
import CoreTransferable
import CryptoKit
 


struct TransactionModel:Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var date: Date
    var amount: Double
    
    init() {
        self.title = "Sample Text"
        self.amount = .random(in: 5000...10000)
        self.date = Calendar.current.date(byAdding: .day, value: .random(in: 1...100), to: .now) ?? .now
    }
}

struct Transactions:Codable, Transferable {
    var transactions:[TransactionModel]
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .trnExportType) { transferable in
            let data = try JSONEncoder().encode(transferable)
            guard let encryptData = try AES.GCM.seal(data, using: .trnKey).combined else {
                throw EncyptionError.failed
            }
            return encryptData
        }.suggestedFileName("Transaction \(Date())")
    }
    enum EncyptionError: Error {
        case failed
    }
    
}

extension SymmetricKey {
    static var trnKey: SymmetricKey {
        let key = "test".data(using: .utf8)!
        let sha256 = SHA256.hash(data: key)
        return .init(data: sha256)
    }
}

extension UTType {
    static var trnExportType = UTType("com.tao.A68-SwiftUI-Custom-File-Extensions-Import-Export.trn")!
}
