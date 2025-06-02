//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Kaider on 02.06.2025.
//

import Foundation
import Combine

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
    
    private let mockData: MockData
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(mockData: MockData = MockData()) {
        self.mockData = mockData
        setupBindings()
        loadCartItems()
    }
    
    // MARK: - Public Methods
    
    func loadCartItems() {
        isLoading = true
        nfts = mockData.nfts
        isLoading = false
    }
    
    func deleteNFT(_ id: String) {
        mockData.nfts.removeAll { $0.id == id }
    }
    
    func getSortedNFTs() -> [Nft] {
        let option = currentSortOption.toProductSortOption()
        return SortingManager.shared.sort(products: nfts, by: option)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        mockData.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.nfts = self?.mockData.nfts ?? []
            }
            .store(in: &cancellables)
    }
}
