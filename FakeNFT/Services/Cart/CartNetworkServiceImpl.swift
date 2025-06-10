//
//  CartNetworkServiceImpl.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

final class CartNetworkServiceImpl: CartNetworkServiceProtocol {
    let networkClient: NetworkClient
    
    enum CartNetworkServiceError: Error {
        case fetchOrderError
        case updateOrderError
        case fetchCurrenciesError
        case payOrderError
    }
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchOrder() async throws -> Order {
        let request = OrderRequest()
        do {
            return try await networkClient.send(request, as: Order.self)
        } catch {
            throw CartNetworkServiceError.fetchOrderError
        }
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        let request = UpdateOrderRequest(nftIds: nftIds)
        do {
            return try await networkClient.send(request, as: Order.self)
        } catch {
            throw CartNetworkServiceError.updateOrderError
        }
    }
    
    func fetchCurrencies() async throws -> [CurrencyModel] {
        let request = CurrenciesRequest()
        do {
            return try await networkClient.send(request, as: [CurrencyModel].self)
        } catch {
            throw CartNetworkServiceError.fetchCurrenciesError
        }
    }
    
    func payOrder(currencyId: String) async throws -> PaymentResult {
        let request = PaymentRequest(currencyId: currencyId)
        do {
            return try await networkClient.send(request, as: PaymentResult.self)
        } catch {
            throw CartNetworkServiceError.payOrderError
        }
    }
}
