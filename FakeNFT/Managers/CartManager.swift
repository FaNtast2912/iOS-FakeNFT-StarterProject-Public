//
//  CartManager.swift
//  FakeNFT
//
//  Created by Kaider on 26.05.2025.
//

import Foundation
import Combine

final class CartManager: ObservableObject {
    @Published private(set) var cartItems: [Product] = []

    private let userDefaultsKey = "FakeNFT_CartItems"
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadCart()
        $cartItems
            .sink { [weak self] items in
                self?.saveCart(items: items)
            }
            .store(in: &cancellables)
    }

    func addToCart(_ product: Product) {
        guard !cartItems.contains(product) else { return }
        cartItems.append(product)
    }

    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.id == product.id }
    }

    func isInCart(_ product: Product) -> Bool {
        cartItems.contains(where: { $0.id == product.id })
    }

    private func saveCart(items: [Product]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }

    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            cartItems = decoded
        }
    }
}
