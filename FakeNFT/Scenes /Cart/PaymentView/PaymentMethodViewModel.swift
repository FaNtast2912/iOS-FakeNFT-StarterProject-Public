//
//  PaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation
import Combine

class PaymentMethodViewModel: ObservableObject {
    @Published var currencies: [CurrencyModel] = []
    @Published var selectedCurrency: CurrencyModel? = nil
    
    func loadCurrencies(from mockData: MockData) {
        self.currencies = mockData.paymentCryptos
    }
}
