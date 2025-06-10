//
//  CartManager.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation

@MainActor
final class CartManager: ObservableObject {
    @Published private(set) var cartItems: [Nft] = []
    @Published private(set) var isLoading = false
    
    private let cartNetworkService: CartNetworkServiceProtocol
    
    init(cartNetworkService: CartNetworkServiceProtocol) {
        self.cartNetworkService = cartNetworkService
        
        Task {
            await loadCart()
        }
    }
    
    func addToCart(_ product: Nft) {
        guard !cartItems.contains(where: { $0.id == product.id }) else { return }
        cartItems.append(product)
        Task {
            await updateOrder()
        }
    }
    
    func removeFromCart(_ product: Nft) {
        cartItems.removeAll { $0.id == product.id }
        Task {
            await updateOrder()
        }
    }
    
    func isInCart(_ product: Nft) -> Bool {
        cartItems.contains(where: { $0.id == product.id })
    }
    
    func clearCart() {
        cartItems.removeAll()
        Task {
            await updateOrder()
        }
    }
    
    private func loadCart() async {
        isLoading = true
        
        do {
            let order = try await cartNetworkService.fetchOrder()
            // Load NFT details would require NftService here
            // This is where we might need to reconsider the manager's dependencies
            
        } catch {
            print("❌ Ошибка загрузки корзины: \(error)")
        }
        
        isLoading = false
    }
    
    private func updateOrder() async {
        do {
            let stringIdArr = cartItems.map { $0.id }
            _ = try await cartNetworkService.updateOrder(nftIds: stringIdArr)
        } catch {
            print("❌ Ошибка обновления корзины: \(error)")
        }
    }
}
