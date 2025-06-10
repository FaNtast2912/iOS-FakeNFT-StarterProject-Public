//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Kaider on 02.06.2025.
//

import Foundation

@MainActor
final class CartViewModel: BaseViewModel<[Nft]> {
    
    // MARK: - Sort Options (сохраняем для совместимости)
    
    enum SortOption: String, CaseIterable {
        case price = "По цене"
        case rating = "По рейтингу"
        case name = "По названию"
        
        func toUnifiedSortOption() -> UnifiedSortOption {
            switch self {
            case .price: return .nftPrice(ascending: true)
            case .rating: return .nftRating(ascending: true)
            case .name: return .nftName(ascending: true)
            }
        }
    }
    
    @Published var currentSortOption: SortOption = .price
    @Published var isDeleting = false
    
    private var cartNetworkService: CartNetworkServiceProtocol {
        servicesAssembly.cartNetworkService
    }
    
    private var nftService: NftServiceProtocol {
        servicesAssembly.nftService
    }
    
    /// Получить NFTs (алиас для совместимости)
    var nfts: [Nft] {
        return loadingState.data ?? []
    }
    
    /// Состояние загрузки (алиас для совместимости)
    var isLoading: Bool {
        return loadingState.isLoading
    }
    
    /// Ошибка (алиас для совместимости)
    var error: Error? {
        return loadingState.error
    }
    
    var formattedTotalPrice: String {
        let total = nfts.reduce(0) { $0 + $1.price }
        return String(format: "%.2f ETH", total)
    }
    
    override func loadData() async {
        print("[CartViewModel] Загрузка корзины...")
        setLoading()
        
        do {
            let order = try await cartNetworkService.fetchOrder()
            print("[CartViewModel] Получен заказ с \(order.nfts.count) NFT")
            
            let nfts = try await nftService.loadNfts(ids: order.nfts)
            setLoaded(nfts)
            
        } catch {
            handleError(error)
        }
    }
    
    /// Загрузить корзину (алиас для совместимости)
    func loadCartItems() {
        Task {
            await loadData()
        }
    }
    
    func deleteNFT(_ id: String) async {
        print("[CartViewModel] Начало удаления NFT: \(id)")
        isDeleting = true
        
        do {
            let currentNfts = loadingState.data ?? []
            let updatedNftIds = currentNfts.compactMap { nft in
                nft.id != id ? nft.id : nil
            }
            
            print("[CartViewModel] Текущее количество NFT: \(currentNfts.count)")
            print("[CartViewModel] Новое количество NFT: \(updatedNftIds.count)")
            
            let updatedOrder = try await cartNetworkService.updateOrder(nftIds: updatedNftIds)
            
            print("[CartViewModel] Сервер подтвердил удаление")
            print("[CartViewModel] Ответ сервера - количество NFT: \(updatedOrder.nfts.count)")
            
            let updatedNfts = try await nftService.loadNfts(ids: updatedOrder.nfts)
            setLoaded(updatedNfts)
            
            isDeleting = false
            print("[CartViewModel] NFT успешно удален из корзины")
            
        } catch {
            handleError(error)
            isDeleting = false
        }
    }
    
    /// Удалить NFT (старый синхронный метод для совместимости)
    func deleteNFT(_ id: String) {
        Task {
            await deleteNFT(id)
        }
    }
    
    func sortItems(by option: SortOption) {
        print("[CartViewModel] Сортировка по: \(option.rawValue)")
        currentSortOption = option
    }
    
    func getSortedNFTs() -> [Nft] {
        let unifiedOption = currentSortOption.toUnifiedSortOption()
        return UnifiedSortingManager.shared.sort(items: nfts, by: unifiedOption) as? [Nft] ?? nfts
    }
}
