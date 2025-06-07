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
        
        func toProductSortOption() -> ProductSortOption {
            switch self {
            case .price: return .price(ascending: true)
            case .rating: return .rating(ascending: true)
            case .name: return .name(ascending: true)
            }
        }
    }
    
    // MARK: - Published Properties
    
    @Published var nfts: [Nft] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentSortOption: SortOption = .price
    
    // MARK: - Dependencies
    
    private let cartManager: CartManager
    private let mockData: MockData
    private var cancellables = Set<AnyCancellable>()
    private var hasInitializedCart = false
    
    @Published private var sessionCartItems: [Nft] = [] // тестовый метод для отладки работы корзины
    
    // MARK: - Computed Properties
    
    var formattedTotalPrice: String {
        let total = nfts.reduce(0) { $0 + $1.price }
        return String(format: "%.2f ETH", total)
    }
    
    // MARK: - Initialization
    
    init(cartManager: CartManager, mockData: MockData = MockData()) {
        self.cartManager = cartManager
        self.mockData = mockData
        setupBindings()
        loadInitialData()
    }
    
    // MARK: - Public Methods
    
    func loadCartItems() {
        isLoading = true
        isLoading = false
    }
    
    func deleteNFT(_ id: String) {
        sessionCartItems.removeAll { $0.id == id }
    }
    
    func getSortedNFTs() -> [Nft] {
        let option = currentSortOption.toProductSortOption()
        return SortingManager.shared.sort(products: nfts, by: option)
    }
    
    func loadMockData() { // тестовый метод для отладки работы корзины
        for nft in mockData.nfts {
            sessionCartItems.append(nft)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        $sessionCartItems
            .receive(on: DispatchQueue.main)
            .assign(to: \.nfts, on: self)
            .store(in: &cancellables)
    }
    
    private func loadInitialData() { // тестовый метод для отладки работы корзины
        guard !hasInitializedCart else { return }
        
        hasInitializedCart = true
        
        Task { @MainActor in
            isLoading = true
            
            sessionCartItems = mockData.nfts
            
            isLoading = false
        }
    }
}
