//
//  CartManager.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import Foundation

actor CartManager {
    private var cartItems: [Nft] = []
    private var isLoading = false
    private var error: Error?
    
    private let cartNetworkService: CartNetworkServiceProtocol
    private let nftService: NftServiceProtocol
    
    init(cartNetworkService: CartNetworkServiceProtocol, nftService: NftServiceProtocol) {
        self.cartNetworkService = cartNetworkService
        self.nftService = nftService
    }
    
    // MARK: - State Access
    
    func getCartItems() -> [Nft] {
        return cartItems
    }
    
    func getTotalPrice() -> Float {
        return cartItems.reduce(0) { $0 + $1.price }
    }
    
    func getItemsCount() -> Int {
        return cartItems.count
    }
    
    func isInCart(_ nftId: String) -> Bool {
        return cartItems.contains { $0.id == nftId }
    }
    
    func isInCart(_ nft: Nft) -> Bool {
        return cartItems.contains { $0.id == nft.id }
    }
    
    func isEmpty() -> Bool {
        return cartItems.isEmpty
    }
    
    func getLoadingState() -> Bool {
        return isLoading
    }
    
    func getError() -> Error? {
        return error
    }
    
    func getNft(by id: String) -> Nft? {
        return cartItems.first { $0.id == id }
    }
    
    // MARK: - Operations
    
    func loadCart() async throws {
        isLoading = true
        error = nil
        
        do {
            let order = try await cartNetworkService.fetchOrder()
            let nfts = try await nftService.loadNfts(ids: order.nfts)
            cartItems = nfts
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            throw error
        }
    }
    
    func addToCart(_ nft: Nft) async throws {
        guard !cartItems.contains(where: { $0.id == nft.id }) else { return }
        
        cartItems.append(nft)
        try await syncWithServer()
    }
    
    func removeFromCart(_ nft: Nft) async throws {
        cartItems.removeAll { $0.id == nft.id }
        try await syncWithServer()
    }
    
    func removeFromCart(nftId: String) async throws {
        cartItems.removeAll { $0.id == nftId }
        try await syncWithServer()
    }
    
    func clearCart() async throws {
        cartItems.removeAll()
        try await syncWithServer()
    }
    
    func addMultipleToCart(_ nfts: [Nft]) async throws {
        for nft in nfts {
            if !cartItems.contains(where: { $0.id == nft.id }) {
                cartItems.append(nft)
            }
        }
        try await syncWithServer()
    }
    
    func removeMultipleFromCart(_ nfts: [Nft]) async throws {
        let idsToRemove = Set(nfts.map { $0.id })
        cartItems.removeAll { idsToRemove.contains($0.id) }
        try await syncWithServer()
    }
    
    // MARK: - Utility
    
    func canAddToCart(_ nft: Nft) -> Bool {
        return !isInCart(nft) && !isLoading
    }
    
    func recoverFromError() async {
        if error != nil {
            do {
                try await loadCart()
            } catch {
                // Error уже установлен в loadCart
            }
        }
    }
    
    // MARK: - Private
    
    private func syncWithServer() async throws {
        do {
            let nftIds = cartItems.map { $0.id }
            _ = try await cartNetworkService.updateOrder(nftIds: nftIds)
            error = nil
        } catch {
            self.error = error
            throw error
        }
    }
    
    #if DEBUG
    func printDebugInfo() {
        print("🛒 Cart Debug Info:")
        print("   Items count: \(cartItems.count)")
        print("   Total price: \(cartItems.reduce(0) { $0 + $1.price })")
        print("   Is loading: \(isLoading)")
        print("   Items: \(cartItems.map { $0.name })")
        if let error = error {
            print("   Error: \(error.localizedDescription)")
        }
    }
    #endif
}

