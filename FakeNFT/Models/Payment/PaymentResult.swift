//
//  PaymentResult.swift
//  FakeNFT
//
//  Created by Kaider on 07.06.2025.
//

import Foundation

struct PaymentResult: Codable {
    let success: Bool
    let orderId: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case orderId = "orderId"
        case id
    }
    
    init(success: Bool, orderId: String? = nil, id: String? = nil) {
        self.success = success
        self.orderId = orderId
        self.id = id
    }
}
