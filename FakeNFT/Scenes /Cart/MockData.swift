//
//  MockData.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import Foundation
import Combine

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
        CurrencyModel(id: "1", name: "Bitcoin", title: "BTC", image: "yp.cripto.bitcoin"),
        CurrencyModel(id: "2", name: "Dogecoin", title: "DOGE", image: "yp.cripto.dogecoin"),
        CurrencyModel(id: "3", name: "Tether", title: "USDT", image: "yp.cripto.tether"),
        CurrencyModel(id: "4", name: "Apecoin", title: "APE", image: "yp.cripto.apeCoin"),
        CurrencyModel(id: "5", name: "Solana", title: "SOL", image: "yp.cripto.solana"),
        CurrencyModel(id: "6", name: "Ethereum", title: "ETH", image: "yp.cripto.ethereum"),
        CurrencyModel(id: "7", name: "Cardano", title: "ADA", image: "yp.cripto.cardano"),
        CurrencyModel(id: "8", name: "Shiba Inu", title: "SHIB", image: "yp.cripto.shibaInu")
    ]
}
