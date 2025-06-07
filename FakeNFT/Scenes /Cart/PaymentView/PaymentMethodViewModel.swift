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
    @Published var isLoading = false
    
    // MARK: - Dependencies
    
    private let cartNetworkService: CartNetworkService?
    
    // MARK: - Initialization
    
    init(cartNetworkService: CartNetworkService) {
        self.cartNetworkService = cartNetworkService
        loadCurrencies()
    }
    
    // Для совместимости с существующим кодом (mock данные)
    init(currencies: [CurrencyModel] = []) {
        self.cartNetworkService = nil
        self.currencies = currencies.isEmpty ? loadMockCurrencies() : currencies
    }
    
    // MARK: - Public Methods
    
    func loadCurrencies() {
        guard let cartNetworkService = cartNetworkService else {
            // Используем mock данные если сервис не предоставлен
            currencies = loadMockCurrencies()
            return
        }
        
        print("[PaymentViewModel] Загрузка валют...")
        isLoading = true
        
        Task {
            do {
                let loadedCurrencies = try await cartNetworkService.fetchCurrencies()
                await MainActor.run {
                    self.currencies = loadedCurrencies
                    self.isLoading = false
                    print("[PaymentViewModel] Загружено валют: \(loadedCurrencies.count)")
                }
            } catch {
                await MainActor.run {
                    self.currencies = self.loadMockCurrencies() // Fallback на mock данные
                    self.isLoading = false
                    print("[PaymentViewModel] Ошибка загрузки валют, используем mock: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func processPayment() async -> Bool {
        showPaymentError = false
        
        // Если валюта не выбрана - будет ошибка оплаты
        guard let selectedCurrency = selectedCurrency else {
            print("[PaymentViewModel] Валюта не выбрана")
            try? await Task.sleep(nanoseconds: 50_000_000)
            showPaymentError = true
            return false
        }
        
        // Если есть сетевой сервис - используем его
        if let cartNetworkService = cartNetworkService {
            return await processNetworkPayment(currencyId: selectedCurrency.id)
        } else {
            // Эмуляция успешной оплаты для mock данных
            print("[PaymentViewModel] Эмуляция успешной оплаты для валюты: \(selectedCurrency.name)")
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунды задержки
            return true
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
    
    private func processNetworkPayment(currencyId: String) async -> Bool {
        print("[PaymentViewModel] Обработка платежа...")
        
        guard let cartNetworkService = cartNetworkService else {
            showPaymentError = true
            return false
        }
        
        do {
            let result = try await cartNetworkService.payOrder(currencyId: currencyId)
            print("[PaymentViewModel] Платеж обработан: success=\(result.success)")
            return result.success
        } catch {
            print("[PaymentViewModel] Ошибка платежа: \(error)")
            showPaymentError = true
            return false
        }
    }
}
