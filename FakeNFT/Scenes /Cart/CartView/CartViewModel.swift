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
    private let cartNetworkService: CartNetworkService
    private let nftService: NftService
    private var cancellables = Set<AnyCancellable>()
    private var hasInitializedCart = false
    
    @Published private var sessionCartItems: [Nft] = []
    
    // MARK: - Computed Properties
    
    var formattedTotalPrice: String {
        let total = nfts.reduce(0) { $0 + $1.price }
        return String(format: "%.2f ETH", total)
    }
    
    // MARK: - Initialization
    
    init(cartManager: CartManager,
         cartNetworkService: CartNetworkService,
         nftService: NftService) {
        self.cartManager = cartManager
        self.cartNetworkService = cartNetworkService
        self.nftService = nftService
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func loadCartItems() {
        print("[CartViewModel] Загрузка корзины...")
        isLoading = true
        error = nil
        
        Task {
            do {
                let order = try await cartNetworkService.fetchOrder()
                print("[CartViewModel] Получен заказ с \(order.nfts.count) NFT")
                
                await loadNftsFromOrder(order.nfts)
                
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                    print("[CartViewModel] Ошибка загрузки корзины: \(error)")
                }
            }
        }
    }

    func deleteNFT(_ id: String) {
        print("[CartViewModel] Удаление NFT: \(id)")
        
        sessionCartItems.removeAll { $0.id == id }
        
        updateCartOnServer()
    }
    
    func sortItems(by option: SortOption) {
        print("[CartViewModel] Сортировка по: \(option.rawValue)")
        currentSortOption = option
    }
    
    func getSortedNFTs() -> [Nft] {
        let option = currentSortOption.toProductSortOption()
        return SortingManager.shared.sort(products: nfts, by: option)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        $sessionCartItems
            .receive(on: DispatchQueue.main)
            .assign(to: \.nfts, on: self)
            .store(in: &cancellables)
    }
    
    private func loadNftsFromOrder(_ nftIds: [String]) async {
        var loadedNfts: [Nft] = []
        
        await withTaskGroup(of: Nft?.self) { group in
            for nftId in nftIds {
                group.addTask { [weak self] in
                    await self?.loadSingleNft(id: nftId)
                }
            }
            
            for await nft in group {
                if let nft = nft {
                    loadedNfts.append(nft)
                }
            }
        }
        
        await MainActor.run {
            self.sessionCartItems = loadedNfts
            self.isLoading = false
            print("[CartViewModel] Корзина загружена: \(loadedNfts.count) NFT")
        }
    }
    
    private func loadSingleNft(id: String) async -> Nft? {
        return await withCheckedContinuation { continuation in
            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    print("[CartViewModel] Загружен NFT: \(nft.name)")
                    continuation.resume(returning: nft)
                case .failure(let error):
                    print("[CartViewModel] Ошибка загрузки NFT \(id): \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func updateCartOnServer() {
        print("[CartViewModel] Синхронизация корзины с сервером...")
        let nftIds = sessionCartItems.map { $0.id }
        
        Task {
            do {
                let updatedOrder = try await cartNetworkService.updateOrder(nftIds: nftIds)
                print("[CartViewModel] Корзина синхронизирована: \(updatedOrder.nfts.count) NFT")
            } catch {
                print("[CartViewModel] Ошибка синхронизации корзины: \(error)")
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
