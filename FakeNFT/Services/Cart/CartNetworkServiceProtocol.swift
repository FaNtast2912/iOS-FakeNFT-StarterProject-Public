//
//  CartService.swift
//  FakeNFT
//
//  Created by Kaider on 07.06.2025.
//

import Foundation

protocol CartNetworkServiceProtocol: ServiceProtocol {
    func fetchOrder() async throws -> Order
    func updateOrder(nftIds: [String]) async throws -> Order
    func fetchCurrencies() async throws -> [CurrencyModel]
    func payOrder(currencyId: String) async throws -> PaymentResult
}
