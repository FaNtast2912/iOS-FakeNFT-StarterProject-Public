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
    @Published var paymentSuccess = false
    
    // MARK: - Dependencies
    
    private let cartNetworkService: CartNetworkServiceProtocol
    
    // MARK: - Initialization
    
    init(cartNetworkService: CartNetworkServiceProtocol) {
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
            await MainActor.run {
                self.showPaymentError = true
            }
            return false
        }
        
        return await processNetworkPayment(currencyId: selectedCurrency.id)
    }
    
    // MARK: - Private Methods
    
    private func processNetworkPayment(currencyId: String) async -> Bool {
        print("[PaymentViewModel] Начало обработки платежа для валюты ID: \(currencyId)")
        
        await MainActor.run {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            // Обрабатываем платеж
            let result = try await cartNetworkService.payOrder(currencyId: currencyId)
            
            if result.success {
                print("[PaymentViewModel] Платеж успешно обработан")
                
                // Очищаем корзину после успешной оплаты
                let clearedOrder = try await clearCartAfterPayment()
                
                await MainActor.run {
                    self.isLoading = false
                    self.paymentSuccess = true
                }
                
                print("[PaymentViewModel] Корзина очищена после оплаты")
                return true
                
            } else {
                print("[PaymentViewModel] Платеж отклонен сервером")
                await MainActor.run {
                    self.isLoading = false
                    self.showPaymentError = true
                }
                return false
            }
            
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.showPaymentError = true
                self.error = error
            }
            print("[PaymentViewModel] Ошибка платежа: \(error)")
            return false
        }
    }
    
    private func clearCartAfterPayment() async throws -> Order {
        print("[PaymentViewModel] Очистка корзины после успешной оплаты...")
        
        // Отправляем пустой список NFT для очистки корзины
        let clearedOrder = try await cartNetworkService.updateOrder(nftIds: [])
        
        print("[PaymentViewModel] Корзина очищена, количество NFT на сервере: \(clearedOrder.nfts.count)")
        return clearedOrder
    }
}
