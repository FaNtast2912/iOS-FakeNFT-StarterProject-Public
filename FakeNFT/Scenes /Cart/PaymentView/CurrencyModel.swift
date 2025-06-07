//
//  CurrencyModel.swift
//  FakeNFT
//
//  Created by [Your Name] on [Date].
//

import Foundation

struct CurrencyModel: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let title: String
    let image: String
    
    // Для совместимости с текущим UI
    var code: String { title }
    var iconName: String { image }
}
