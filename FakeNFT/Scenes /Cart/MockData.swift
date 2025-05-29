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

    let paymentCryptos: [PaymentCrypto] = [
        PaymentCrypto(icon: "yp.cripto.bitcoin",   title: "Bitcoin",    subtitle: "BTC"),
        PaymentCrypto(icon: "yp.cripto.dogecoin",  title: "Dogecoin",   subtitle: "DOGE"),
        PaymentCrypto(icon: "yp.cripto.tether",    title: "Tether",     subtitle: "USDT"),
        PaymentCrypto(icon: "yp.cripto.apeCoin",   title: "Apecoin",    subtitle: "APE"),
        PaymentCrypto(icon: "yp.cripto.solana",    title: "Solana",     subtitle: "SOL"),
        PaymentCrypto(icon: "yp.cripto.ethereum",  title: "Ethereum",   subtitle: "ETH"),
        PaymentCrypto(icon: "yp.cripto.cardano",   title: "Cardano",    subtitle: "ADA"),
        PaymentCrypto(icon: "yp.cripto.shibalnu",  title: "Shiba Inu",  subtitle: "SHIB"),
    ]
}
