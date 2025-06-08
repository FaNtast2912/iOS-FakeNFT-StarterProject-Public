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
    @Published var isDeleting = false
    
    // MARK: - Dependencies
    
    private let cartManager: CartManager
    private let cartNetworkService: CartNetworkService
    private let nftService: NftService
    private var cancellables = Set<AnyCancellable>()
    
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
                
                ///Метод автоматически добавляет тестовый NFT, если корзина пустая
                ///Раскомментировать для тестирования функций удаления корзины
//                if order.nfts.isEmpty {
//                    print("[CartViewModel] Корзина пустая, добавляем тестовый NFT автоматически")
//                    await addTestNFTAutomatically()
//                } else {
//                    await loadNftsFromOrder(order.nfts)
//                }
                
                /// Закомментировать если прошлая функция  if order.nfts.isEmpty была раскомментирована
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
      
    ///Раскомментировать для тестирования функций удаления корзины
//    private func addTestNFTAutomatically() async {
//        print("[CartViewModel] Автоматическое добавление тестового NFT...")
//        
//        do {
//            let testNftIds = ["2c9d09f6-25ac-4d6f-8d6a-175c4de2b42f"]
//            
//            print("[CartViewModel] Добавляем тестовый NFT: \(testNftIds)")
//            
//            let updatedOrder = try await cartNetworkService.updateOrder(nftIds: testNftIds)
//            print("[CartViewModel] Сервер подтвердил добавление: \(updatedOrder.nfts)")
//            
//            await loadNftsFromOrder(updatedOrder.nfts)
//            
//            await MainActor.run {
//                self.isLoading = false
//                print("[CartViewModel] Тестовый NFT добавлен")
//            }
//            
//        } catch {
//            await MainActor.run {
//                self.error = error
//                self.isLoading = false
//                print("[CartViewModel] Ошибка добавления тестового NFT: \(error)")
//            }
//        }
//    }
    
    func deleteNFT(_ id: String) {
        print("[CartViewModel] Начало удаления NFT: \(id)")
        isDeleting = true
        error = nil
        
        Task {
            do {
                let updatedNftIds = nfts.compactMap { nft in
                    nft.id != id ? nft.id : nil
                }
                
                print("[CartViewModel] Текущее количество NFT: \(nfts.count)")
                print("[CartViewModel] Новое количество NFT: \(updatedNftIds.count)")
                print("[CartViewModel] Отправка обновленного списка на сервер: \(updatedNftIds)")
                
                let updatedOrder = try await cartNetworkService.updateOrder(nftIds: updatedNftIds)
                
                print("[CartViewModel] Сервер подтвердил удаление")
                print("[CartViewModel] Ответ сервера - количество NFT: \(updatedOrder.nfts.count)")
                print("[CartViewModel] Новый список на сервере: \(updatedOrder.nfts)")
                
                await loadNftsFromOrder(updatedOrder.nfts)
                
                await MainActor.run {
                    self.isDeleting = false
                    print("[CartViewModel] NFT успешно удален из корзины")
                }
                
            } catch let error as NetworkClientError {
                await MainActor.run {
                    self.error = error
                    self.isDeleting = false
                    print("[CartViewModel] Ошибка сети при удалении NFT: \(error)")
                    
                    switch error {
                    case .httpStatusCode(let statusCode):
                        print("[CartViewModel] HTTP статус код: \(statusCode)")
                        if statusCode == 406 {
                            print("[CartViewModel] Сервер не принимает пустой список NFT")
                        }
                    case .urlRequestError(let urlError):
                        print("[CartViewModel] URL ошибка: \(urlError)")
                    default:
                        print("[CartViewModel] Другая сетевая ошибка: \(error)")
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isDeleting = false
                    print("[CartViewModel] Общая ошибка удаления NFT: \(error)")
                }
            }
        }
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
    
    private func loadNftsFromOrder(_ nftIds: [String]) async {
        print("[CartViewModel] Загрузка \(nftIds.count) NFT по ID...")
        
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
            self.nfts = loadedNfts
            self.isLoading = false
            print("[CartViewModel] Корзина обновлена: \(loadedNfts.count) NFT")
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
}
