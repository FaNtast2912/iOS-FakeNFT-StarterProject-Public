//
//  CurrencyModel.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation

struct CurrencyModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let code: String
    let iconName: String  // имя SF Symbol или ассета
}
