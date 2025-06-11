//
//  PaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025
//

import SwiftUI

@MainActor
final class PaymentMethodViewModel: BaseViewModel<[CurrencyModel]> {
    @Published var selectedCurrency: CurrencyModel? = nil
    @Published var showPaymentError = false
    @Published var paymentSuccess = false
    
    private var cartNetworkService: CartNetworkServiceProtocol {
        servicesAssembly.cartNetworkService
    }
    
    /// Получить валюты (алиас для совместимости)
    var currencies: [CurrencyModel] {
        return loadingState.data ?? []
    }
    
    /// Состояние загрузки (алиас для совместимости)
    var isLoading: Bool {
        return loadingState.isLoading
    }
    
    /// Ошибка (алиас для совместимости)
    var error: Error? {
        return loadingState.error
    }
    
    override func loadData() async {
        print("[PaymentViewModel] Загрузка валют...")
        setLoading()
        
        do {
            let currencies = try await cartNetworkService.fetchCurrencies()
            print("[PaymentViewModel] Загружено валют: \(currencies.count)")
            setLoaded(currencies)
        } catch {
            handleError(error)
        }
    }
    
    /// Загрузить валюты (алиас для совместимости)
    func loadCurrencies() {
        Task {
            await loadData()
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
    
    private func processNetworkPayment(currencyId: String) async -> Bool {
        print("[PaymentViewModel] Начало обработки платежа для валюты ID: \(currencyId)")
        
        do {
            let result = try await cartNetworkService.payOrder(currencyId: currencyId)
            
            if result.success {
                print("[PaymentViewModel] Платеж успешно обработан")
                
                // Очищаем корзинку
                try await servicesAssembly.cartManager.clearCart()
                
                paymentSuccess = true
                return true
                
            } else {
                print("[PaymentViewModel] Платеж отклонен сервером")
                showPaymentError = true
                return false
            }
            
        } catch {
            handleError(error)
            showPaymentError = true
            return false
        }
    }
}
