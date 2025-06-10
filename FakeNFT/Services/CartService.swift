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
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        let request = UpdateOrderRequest(nftIds: nftIds)
        let order = try await networkClient.send(request, as: Order.self)
        return order
    }
    
    func fetchOrder() async throws -> Order {
        let request = OrderRequest()
        let order = try await networkClient.send(request, as: Order.self)
        return order
    }
    
    func fetchCurrencies() async throws -> [CurrencyModel] {
        let request = CurrenciesRequest()
        let currencies = try await networkClient.send(request, as: [CurrencyModel].self)
        return currencies
    }
    
    func fetchCurrency(id: String) async throws -> CurrencyModel {
        let request = CurrencyRequest(id: id)
        let currency = try await networkClient.send(request, as: CurrencyModel.self)
        return currency
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        let request = PaymentRequest(currencyId: currencyId)
        let result = try await networkClient.send(request, as: PaymentResult.self)
        return result
    }
}
