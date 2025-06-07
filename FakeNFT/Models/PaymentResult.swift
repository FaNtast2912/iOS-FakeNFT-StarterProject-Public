//
//  PaymentResult.swift
//  FakeNFT
//
//  Created by Kaider on 07.06.2025.
//

import Foundation

struct PaymentResult: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
