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
                
                /// Закомментировать если прошлая функция if order.nfts.isEmpty была раскомментирована
                await loadNftsFromOrder(order.nfts)
                
            } catch let networkError as NetworkClientError {
                await handleNetworkError(networkError, context: "загрузка корзины")
            } catch {
                await handleGenericError(error, context: "загрузка корзины")
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
//        } catch let networkError as NetworkClientError {
//            await handleNetworkError(networkError, context: "добавление тестового NFT")
//        } catch {
//            await handleGenericError(error, context: "добавление тестового NFT")
//        }
//    }
    
    func deleteNFT(_ id: String) {
        print("[CartViewModel] Начало удаления NFT: \(id)")
        isDeleting = true
        error = nil
        
        Task { [weak self] in
            guard let self = self else { return }
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
                
            } catch let networkError as NetworkClientError {
                await handleNetworkError(networkError, context: "удаление NFT")
                await MainActor.run { self.isDeleting = false }
            } catch {
                await handleGenericError(error, context: "удаление NFT")
                await MainActor.run { self.isDeleting = false }
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
    
    // MARK: - Error Handling
    
    @MainActor
    private func handleNetworkError(_ error: NetworkClientError, context: String) {
        isLoading = false
        print("[CartViewModel] NetworkClientError при \(context): \(error)")
        
        self.error = error
        
        switch error {
        case .httpStatusCode(let statusCode):
            print("[CartViewModel] HTTP статус код: \(statusCode)")
        case .urlRequestError(let urlError):
            print("[CartViewModel] URL ошибка: \(urlError)")
        case .urlSessionError:
            print("[CartViewModel] URL Session ошибка")
        case .parsingError:
            print("[CartViewModel] Ошибка парсинга данных")
        case .invalidEndpoint:
            print("[CartViewModel] Некорректный endpoint")
        case .invalidResponse:
            print("[CartViewModel] Некорректный ответ сервера")
        }
    }
    
    @MainActor
    private func handleGenericError(_ error: Error, context: String) {
        isLoading = false
        print("[CartViewModel] Общая ошибка при \(context): \(error)")
        self.error = error
    }
    
    // MARK: - Private Methods
    
    @MainActor
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
        
        nfts = loadedNfts
        isLoading = false
        print("[CartViewModel] Корзина обновлена: \(loadedNfts.count) NFT")
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
