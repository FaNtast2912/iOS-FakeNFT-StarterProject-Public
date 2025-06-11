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
    
    // Убрана дублирующая логика - используем CartManager через ServicesAssembly
    
    /// Получить NFTs (теперь из CartManager)
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
        print("[CartViewModel] Загрузка корзины через CartManager...")
        setLoading()
        
        do {
            // Используем CartManager вместо прямого обращения к сервисам
            try await servicesAssembly.cartManager.loadCart()
            let cartItems = await servicesAssembly.cartManager.getCartItems()
            
            print("[CartViewModel] Получено \(cartItems.count) NFT из CartManager")
            setLoaded(cartItems)
            
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
            // Находим NFT для удаления
            guard let nftToDelete = nfts.first(where: { $0.id == id }) else {
                print("[CartViewModel] NFT не найден для удаления")
                isDeleting = false
                return
            }
            
            // Используем CartManager для удаления
            try await servicesAssembly.cartManager.removeFromCart(nftToDelete)
            
            // Обновляем локальное состояние
            let updatedItems = await servicesAssembly.cartManager.getCartItems()
            setLoaded(updatedItems)
            
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
