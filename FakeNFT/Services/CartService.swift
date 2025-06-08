//
//  CartService.swift
//  FakeNFT
//
//  Created by Kaider on 07.06.2025.
//

import Foundation

protocol CartNetworkService {
    /// Получение текущего заказа пользователя
    func fetchOrder() async throws -> Order
    
    /// Обновление заказа (добавление/удаление NFT)
    func updateOrder(nftIds: [String]) async throws -> Order
    
    /// Получение списка валют для оплаты
    func fetchCurrencies() async throws -> [CurrencyModel]
    
    /// Получение информации о конкретной валюте
    func fetchCurrency(id: String) async throws -> CurrencyModel
    
    /// Оплата заказа выбранной валютой
    func payOrder(currencyId: String) async throws -> PaymentResult
}

final class DefaultCartNetworkService: CartNetworkService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchOrder() async throws -> Order {
        return try await withCheckedThrowingContinuation { continuation in
            let request = OrderRequest()
            networkClient.send(request: request, type: Order.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        return try await withCheckedThrowingContinuation { continuation in
            let request = UpdateOrderRequest(nftIds: nftIds)
            networkClient.send(request: request, type: Order.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func fetchCurrencies() async throws -> [CurrencyModel] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = CurrenciesRequest()
            networkClient.send(request: request, type: [CurrencyModel].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func fetchCurrency(id: String) async throws -> CurrencyModel {
        return try await withCheckedThrowingContinuation { continuation in
            let request = CurrencyRequest(id: id)
            networkClient.send(request: request, type: CurrencyModel.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        return try await withCheckedThrowingContinuation { continuation in
            let request = PaymentRequest(currencyId: currencyId)
            networkClient.send(request: request, type: PaymentResult.self) { result in
                continuation.resume(with: result)
            }
        }
    }
}
