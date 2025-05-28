//
//  MockData.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import Foundation
import Combine

final class MockData: ObservableObject {
    @Published var nftCount: Int = 3
    @Published var totalCostNft: Double = 5.34
    @Published var nftName = ["April", "Greena", "Spring"]
}
