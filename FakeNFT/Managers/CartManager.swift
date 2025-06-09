//
//  CartManager.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation
import Combine

final class CartManager: ObservableObject {
    @Published private(set) var cartItems: [Nft] = []
    
    private let cartNetworkService: CartNetworkService
    private let userDefaultsKey = "FakeNFT_CartItems"
    private var cancellables = Set<AnyCancellable>()
    
    init(cartNetworkService: CartNetworkService) {
        self.cartNetworkService = cartNetworkService
        
        Task {
            await loadCart()
        }
        
        $cartItems
            .dropFirst()
            .sink { [weak self] items in
                Task {
                    await self?.saveCart(items: items)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func addToCart(_ product: Nft) {
        guard !cartItems.contains(where: { $0.id == product.id }) else { return }
        cartItems.append(product)
        Task {
            await updateOrder()
        }
    }
    
    @MainActor
    func removeFromCart(_ product: Nft) {
        cartItems.removeAll { $0.id == product.id }
        Task {
            await updateOrder()
        }
    }
    
    @MainActor
    func isInCart(_ product: Nft) -> Bool {
        cartItems.contains(where: { $0.id == product.id })
    }
    
    @MainActor
    func clearCart() {
        cartItems.removeAll()
        Task {
            await updateOrder()
        }
    }
    
    @MainActor
    private func updateOrder() async {
        do {
            let stringIdArr = cartItems.map { $0.id }
            _ = try await cartNetworkService.updateOrder(nftIds: stringIdArr)
            
        } catch let networkError as NetworkClientError {
            print(networkError)
        } catch {
            print(error)
        }
    }
    
    private func saveCart(items: [Nft]) async {
        do {
            let data = try JSONEncoder().encode(items)
            try await saveToUserDefaults(data)
        } catch {
            print("Ошибка при сохранении корзины: \(error)")
        }
    }
    
    @MainActor
    private func loadCart() async {
        do {
            if let data = try await loadFromUserDefaults() {
                do {
                    let decoded = try JSONDecoder().decode([Nft].self, from: data)
                    cartItems = decoded
                } catch {
                    print("Ошибка декодирования корзины: \(error)")
                }
            }
        } catch {
            print("Ошибка при загрузке корзины: \(error)")
        }
    }
    
    private func saveToUserDefaults(_ data: Data) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
                continuation.resume()
            }
        }
    }
    
    private func loadFromUserDefaults() async throws -> Data? {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                let data = UserDefaults.standard.data(forKey: self.userDefaultsKey)
                continuation.resume(returning: data)
            }
        }
    }
}
