//
//  PaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by [Your Name] on [Date].
//

import Combine
import SwiftUI

@MainActor
final class PaymentMethodViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var currencies: [CurrencyModel] = []
    @Published var selectedCurrency: CurrencyModel? = nil
    @Published var showPaymentError = false
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Dependencies
    
    private let cartNetworkService: CartNetworkService
    
    // MARK: - Initialization
    
    init(cartNetworkService: CartNetworkService) {
        self.cartNetworkService = cartNetworkService
    }
    
    // MARK: - Public Methods
    
    func loadCurrencies() {
        print("[PaymentViewModel] Загрузка валют с сервера...")
        isLoading = true
        error = nil
        
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
                    self.error = error
                    self.isLoading = false
                    print("[PaymentViewModel] Ошибка загрузки валют: \(error)")
                }
            }
        }
    }
    
    func processPayment() async -> Bool {
        showPaymentError = false
        
        guard let selectedCurrency = selectedCurrency else {
            print("[PaymentViewModel] Валюта не выбрана")
            showPaymentError = true
            return false
        }
        
        return await processNetworkPayment(currencyId: selectedCurrency.id)
    }
    
    // MARK: - Private Methods
    
    private func processNetworkPayment(currencyId: String) async -> Bool {
        print("[PaymentViewModel] Обработка платежа для валюты: \(currencyId)")
        isLoading = true
        
        do {
            let result = try await cartNetworkService.payOrder(currencyId: currencyId)
            await MainActor.run {
                self.isLoading = false
            }
            print("[PaymentViewModel] Платеж обработан: success=\(result.success)")
            return result.success
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.showPaymentError = true
            }
            print("[PaymentViewModel] Ошибка платежа: \(error)")
            return false
        }
    }
}
