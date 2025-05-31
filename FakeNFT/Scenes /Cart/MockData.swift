//
//  MockData.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import Foundation
import Combine

struct PaymentCrypto: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

struct CartNFT: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let price: Double
    let imageUrl: String?
}

final class MockData: ObservableObject {
    @Published var cartNFTs: [CartNFT] = [
        CartNFT(name: "April", price: 9.68, imageUrl: nil),
        CartNFT(name: "Greena", price: 2.05, imageUrl: nil),
        CartNFT(name: "Spring", price: 1.51, imageUrl: nil)
    ]
    
    var nftCount: Int {
        cartNFTs.count
    }
    
    var totalCostNft: Double {
        cartNFTs.reduce(0) { $0 + $1.price }
    }
    
    var nftNames: [String] {
        cartNFTs.map { $0.name }
    }
    
    let paymentCryptos: [CurrencyModel] = [
        CurrencyModel(name: "Bitcoin", code: "BTC", iconName: "yp.cripto.bitcoin"),
        CurrencyModel(name: "Dogecoin", code: "DOGE", iconName: "yp.cripto.dogecoin"),
        CurrencyModel(name: "Tether", code: "USDT", iconName: "yp.cripto.tether"),
        CurrencyModel(name: "Apecoin", code: "APE", iconName: "yp.cripto.apeCoin"),
        CurrencyModel(name: "Solana", code: "SOL", iconName: "yp.cripto.solana"),
        CurrencyModel(name: "Ethereum", code: "ETH", iconName: "yp.cripto.ethereum"),
        CurrencyModel(name: "Cardano", code: "ADA", iconName: "yp.cripto.cardano"),
        CurrencyModel(name: "Shiba Inu", code: "SHIB", iconName: "yp.cripto.shibaInu")
    ]
}
