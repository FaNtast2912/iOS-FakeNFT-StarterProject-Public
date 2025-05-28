//
//  PaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation
import Combine

class PaymentMethodViewModel: ObservableObject {
    @Published var currencies: [CurrencyModel] = [
        CurrencyModel(name: "Bitcoin", code: "BTC", iconName: "btc"),
        CurrencyModel(name: "Tether", code: "USDT", iconName: "usdt"),
        CurrencyModel(name: "Solana", code: "SOL", iconName: "solana"),
        CurrencyModel(name: "Cardano", code: "ADA", iconName: "cardano"),
        CurrencyModel(name: "Dogecoin", code: "DOGE", iconName: "dogecoin"),
        CurrencyModel(name: "Apecoin", code: "APE", iconName: "apecoin"),
        CurrencyModel(name: "Ethereum", code: "ETH", iconName: "ethereum"),
        CurrencyModel(name: "Shiba Inu", code: "SHIB", iconName: "shiba")
    ]
    @Published var selectedCurrency: CurrencyModel? = nil
}
