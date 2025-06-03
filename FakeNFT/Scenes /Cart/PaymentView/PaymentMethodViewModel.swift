//
//  PaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by [Your Name] on [Date].
//

import Combine
import SwiftUI

final class PaymentMethodViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var currencies: [CurrencyModel] = []
    @Published var selectedCurrency: CurrencyModel? = nil
    @Published var showPaymentError = false
    
    // MARK: - Initialization
    
    init(currencies: [CurrencyModel] = []) {
        if currencies.isEmpty {
            self.currencies = loadMockCurrencies()
        } else {
            self.currencies = currencies
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMockCurrencies() -> [CurrencyModel] {
        return [
            CurrencyModel(id: "1", name: "Bitcoin", title: "BTC", image: "yp.cripto.bitcoin"),
            CurrencyModel(id: "2", name: "Ethereum", title: "ETH", image: "yp.cripto.ethereum"),
            CurrencyModel(id: "3", name: "Dogecoin", title: "DOGE", image: "yp.cripto.dogecoin")
        ]
    }
    
    @MainActor
    func processPayment() async -> Bool {
        showPaymentError = false
        // Если валюта не выбрана - будет ошибка оплаты
        guard selectedCurrency != nil else {
            try? await Task.sleep(nanoseconds: 50_000_000)
            showPaymentError = true
            return false
        }
        // Остальные параметры
        return true
    }
}
