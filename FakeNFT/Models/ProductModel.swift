//
//  ProductModel.swift
//  FakeNFT
//
//  Created by Kaider on 26.05.2025.
//

import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let rating: Double
    let price: Double
    let nftCount: Int
}
