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
    @Published private(set) var isLoading = false
    
    private let cartNetworkService: CartNetworkService
    private let networkClient: NetworkClient
    
    init(cartNetworkService: CartNetworkService, networkClient: NetworkClient) {
        self.cartNetworkService = cartNetworkService
        self.networkClient = networkClient
        
        Task {
            await loadCartFromServer()
        }
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func addToCart(_ product: Nft) async {
        guard isValidNFTId(product.id) else {
            print("❌ CartManager: Некорректный ID NFT: \(product.id)")
            return
        }
        
        guard !cartItems.contains(where: { $0.id == product.id }) else {
            return
        }
        
        isLoading = true
        
        cartItems.append(product)
        
        let allIds = cartItems.map { $0.id }
        await updateServerCart(with: allIds)
        
        isLoading = false
    }
    
    @MainActor
    func removeFromCart(_ product: Nft) async {
        isLoading = true
        
        cartItems.removeAll { $0.id == product.id }
        
        let allIds = cartItems.map { $0.id }
        await updateServerCart(with: allIds)
        
        isLoading = false
    }
    
    @MainActor
    func clearCart() async {
        isLoading = true
        
        cartItems.removeAll()
        
        await updateServerCart(with: [])
        
        isLoading = false
    }
    
    @MainActor
    func refreshCart() async {
        await loadCartFromServer()
    }
    
    @MainActor
    func isInCart(_ product: Nft) -> Bool {
        cartItems.contains(where: { $0.id == product.id })
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func loadCartFromServer() async {
        isLoading = true
        
        do {
            let order = try await cartNetworkService.fetchOrder()

            let validIds = order.nfts.filter { isValidNFTId($0) }
            
            if validIds != order.nfts {
                await updateServerCart(with: validIds)
            }
            
            await loadNFTDetails(for: validIds)
            
        } catch {
            print("CartManager: Ошибка загрузки корзины: \(error)")
            cartItems = []
        }
        
        isLoading = false
    }
    
    @MainActor
    private func loadNFTDetails(for ids: [String]) async {
        guard !ids.isEmpty else {
            cartItems = []
            return
        }
        
        var loadedNFTs: [Nft] = []
        
        await withTaskGroup(of: (String, Nft?).self) { group in
            for id in ids {
                group.addTask { [weak self] in
                    do {
                        let nft = try await self?.loadNFTById(id)
                        return (id, nft)
                    } catch {
                        print("CartManager: Ошибка загрузки NFT \(id): \(error)")
                        return (id, nil)
                    }
                }
            }
            
            for await (id, nft) in group {
                if let nft = nft {
                    loadedNFTs.append(nft)
                }
            }
        }
        
        cartItems = ids.compactMap { id in
            loadedNFTs.first { $0.id == id }
        }
    }
    
    private func updateServerCart(with ids: [String]) async {
        do {
            let _ = try await cartNetworkService.updateOrder(nftIds: ids)
            
        } catch {
            print("CartManager: Ошибка обновления корзины: \(error)")
            
            await MainActor.run {
                Task {
                    await loadCartFromServer()
                }
            }
        }
    }
    
    private func isValidNFTId(_ id: String) -> Bool {
        return id.count > 10 && id.contains("-")
    }
    
    // MARK: - Helper method для загрузки NFT по ID
    
    private func loadNFTById(_ id: String) async throws -> Nft {
        let request = NFTRequest(id: id)
        return try await networkClient.send(request, as: Nft.self)
    }
}

// MARK: - Sync methods для совместимости с существующим кодом

extension CartManager {
    @MainActor
    func addToCart(_ product: Nft) {
        Task {
            await addToCart(product)
        }
    }
    
    @MainActor
    func removeFromCart(_ product: Nft) {
        Task {
            await removeFromCart(product)
        }
    }
    
    @MainActor
    func clearCart() {
        Task {
            await clearCart()
        }
    }
}
