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

final class MockData: ObservableObject {
    @Published var nftCount: Int = 3
    @Published var totalCostNft: Double = 5.34
    @Published var nftName = ["April", "Greena", "Spring"]
    
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
