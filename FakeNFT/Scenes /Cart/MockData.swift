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
    @Published var nfts: [Nft] = [
        Nft(
            id: "1",
            name: "April",
            createdAt: "2024-05-01",
            images: [],
            rating: 5,
            description: "Spring NFT.",
            price: 9.68,
            author: "Author1"
        ),
        Nft(
            id: "2",
            name: "Greena",
            createdAt: "2024-05-02",
            images: [],
            rating: 4,
            description: "Green NFT.",
            price: 2.05,
            author: "Author2"
        ),
        Nft(
            id: "3",
            name: "Spring",
            createdAt: "2024-05-03",
            images: [],
            rating: 3,
            description: "Spring Vibes.",
            price: 1.51,
            author: "Author3"
        )
    ]
    
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
