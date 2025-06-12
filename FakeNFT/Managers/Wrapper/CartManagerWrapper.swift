//
//  CartManagerWrapper.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 11.06.2025.
//

import SwiftUI
import Foundation

@MainActor
final class CartManagerWrapper: ObservableObject {
    @Published var items: [Nft] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let cartManager: CartManager
    private var updateTask: Task<Void, Never>?
    
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        startPeriodicUpdates()
    }
    
    deinit {
        updateTask?.cancel()
    }
    
    // MARK: - Computed Properties
    
    var totalPrice: Float {
        items.reduce(0) { $0 + $1.price }
    }
    
    var itemsCount: Int {
        items.count
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    // MARK: - State Checks
    
    func isInCart(_ nft: Nft) -> Bool {
        items.contains { $0.id == nft.id }
    }
    
    func isInCart(_ nftId: String) -> Bool {
        items.contains { $0.id == nftId }
    }
    
    // MARK: - Actions
    
    func addToCart(_ nft: Nft) {
        guard !isInCart(nft) && !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.cartManager.addToCart(nft)
            }
        }
    }
    
    func removeFromCart(_ nft: Nft) {
        guard isInCart(nft) && !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.cartManager.removeFromCart(nft)
            }
        }
    }
    
    func toggleCart(_ nft: Nft) {
        if isInCart(nft) {
            removeFromCart(nft)
        } else {
            addToCart(nft)
        }
    }
    
    func clearCart() {
        guard !isEmpty && !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.cartManager.clearCart()
            }
        }
    }
    
    func loadCart() {
        Task {
            await performAction { [weak self] in
                try await self?.cartManager.loadCart()
            }
        }
    }
    
    func refresh() {
        loadCart()
    }
    
    // MARK: - Private Methods
    
    private func startPeriodicUpdates() {
        updateTask = Task {
            while !Task.isCancelled {
                await updateState()
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            }
        }
    }
    
    private func updateState() async {
        let newItems = await cartManager.getCartItems()
        let newIsLoading = await cartManager.getLoadingState()
        let newError = await cartManager.getError()
        
        items = newItems
        isLoading = newIsLoading
        error = newError
    }
    
    private func performAction(_ action: @escaping () async throws -> Void) async {
        isLoading = true
        error = nil
        
        do {
            try await action()
            await updateState()
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
