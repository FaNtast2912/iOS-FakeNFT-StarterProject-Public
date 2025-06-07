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
        print("[CartService] Запрос заказа...")
        let request = OrderRequest()
        print("[CartService] URL: \(request.endpoint?.absoluteString ?? "nil")")
        
        do {
            let order = try await networkClient.send(request, as: Order.self)
            print("[CartService] Заказ получен: \(order.nfts.count) NFT")
            print("[CartService] NFT IDs: \(order.nfts)")
            return order
        } catch {
            print("[CartService] Ошибка получения заказа: \(error)")
            throw error
        }
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        print("[CartService] Обновление заказа...")
        print("[CartService] Новые NFT IDs: \(nftIds)")
        let request = UpdateOrderRequest(nftIds: nftIds)
        print("[CartService] URL: \(request.endpoint?.absoluteString ?? "nil")")
        
        do {
            let order = try await networkClient.send(request, as: Order.self)
            print("[CartService] Заказ обновлен: \(order.nfts.count) NFT")
            print("[CartService] Обновленные NFT IDs: \(order.nfts)")
            return order
        } catch {
            print("[CartService] Ошибка обновления заказа: \(error)")
            throw error
        }
    }
    
    func fetchCurrencies() async throws -> [CurrencyModel] {
        print("[CartService] Запрос списка валют...")
        let request = CurrenciesRequest()
        print("[CartService] URL: \(request.endpoint?.absoluteString ?? "nil")")
        
        do {
            let currencies = try await networkClient.send(request, as: [CurrencyModel].self)
            print("[CartService] Получено валют: \(currencies.count)")
            for currency in currencies {
                print("[CartService] Валюта: \(currency.name) (\(currency.title))")
            }
            return currencies
        } catch {
            print("[CartService] Ошибка получения валют: \(error)")
            throw error
        }
    }
    
    func fetchCurrency(id: String) async throws -> CurrencyModel {
        print("[CartService] Запрос валюты с ID: \(id)")
        let request = CurrencyRequest(id: id)
        print("[CartService] URL: \(request.endpoint?.absoluteString ?? "nil")")
        
        do {
            let currency = try await networkClient.send(request, as: CurrencyModel.self)
            print("[CartService] Получена валюта: \(currency.name) (\(currency.title))")
            return currency
        } catch {
            print("[CartService] Ошибка получения валюты: \(error)")
            throw error
        }
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        print("[CartService] Оплата заказа валютой ID: \(currencyId)")
        let request = PaymentRequest(currencyId: currencyId)
        print("[CartService] URL: \(request.endpoint?.absoluteString ?? "nil")")
        
        do {
            let result = try await networkClient.send(request, as: PaymentResult.self)
            print("[CartService] Результат оплаты: success=\(result.success)")
            print("[CartService] Order ID: \(result.orderId)")
            return result
        } catch {
            print("[CartService] Ошибка оплаты: \(error)")
            throw error
        }
    }
}
