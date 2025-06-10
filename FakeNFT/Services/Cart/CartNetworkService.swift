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
