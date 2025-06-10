//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Kaider on 02.06.2025.
//

import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    
    // MARK: - Sort Options
    
    enum SortOption: String, CaseIterable {
        case price = "По цене"
        case rating = "По рейтингу"
        case name = "По названию"
    }
    
    // MARK: - Published Properties
    
    @Published var nfts: [Nft] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentSortOption: SortOption = .price
    @Published var isDeleting = false
    
    // MARK: - Dependencies

    private let cartManager: CartManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var formattedTotalPrice: String {
        let total = nfts.reduce(0.0) { $0 + Double($1.price) }
        return String(format: "%.2f ETH", total)
    }
    
    // MARK: - Initialization
    
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        
        cartManager.$cartItems
            .receive(on: DispatchQueue.main)
            .assign(to: \.nfts, on: self)
            .store(in: &cancellables)
            
        cartManager.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func loadCartItems() {
        Task {
            await cartManager.refreshCart()
        }
    }
    
    func deleteNFT(_ id: String) async {
        guard let nft = nfts.first(where: { $0.id == id }) else {
            print("CartViewModel: NFT с ID \(id) не найден в корзине")
            return
        }
        
        isDeleting = true
        await cartManager.removeFromCart(nft)
        isDeleting = false
    }
    
    func sortItems(by option: SortOption) {
        currentSortOption = option
    }
    
    func getSortedNFTs() -> [Nft] {
        switch currentSortOption {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted { $0.name < $1.name }
        }
    }
    
    func clearCart() async {
        await cartManager.clearCart()
    }
    
    func isInCart(_ nft: Nft) -> Bool {
        return cartManager.isInCart(nft)
    }
    
    // MARK: - Error Handling
    
    @MainActor
    private func handleGenericError(_ error: Error, context: String) {
        print("CartViewModel: Ошибка в \(context): \(error.localizedDescription)")
        self.error = error
    }
}

// MARK: - Extensions

extension CartViewModel {
    
    var isEmpty: Bool {
        return nfts.isEmpty
    }
    
    var itemCount: Int {
        return nfts.count
    }
    
    var totalPrice: Double {
        return nfts.reduce(0.0) { $0 + Double($1.price) }
    }
    
    func getNft(by id: String) -> Nft? {
        return nfts.first { $0.id == id }
    }
}
