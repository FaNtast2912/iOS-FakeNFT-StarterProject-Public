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

    private let cartNetworkService: CartNetworkService
    private let nftService: NftService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    
    var formattedTotalPrice: String {
        let total = nfts.reduce(0) { $0 + $1.price }
        return String(format: "%.2f ETH", total)
    }
    
    // MARK: - Initialization
    
    init(cartNetworkService: CartNetworkService,
         nftService: NftService) {
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
                
                await loadNftsFromOrder(order.nfts)
                
            } catch let networkError as NetworkClientError {
                await handleNetworkError(networkError, context: "загрузка корзины")
            } catch {
                await handleGenericError(error, context: "загрузка корзины")
            }
        }
    }
    
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
    
    func loadNfts(for user: User) async {
        isLoading = true
        defer { isLoading = false }

        var loadedNfts: [Nft] = []

        for id in user.nfts {
            do {
                let nft = try await nftService.loadNft(id: id)
                loadedNfts.append(nft)
            } catch {
                print("Ошибка загрузки NFT с id=\(id): \(error)")
            }
        }
        nfts = loadedNfts
    }
    
    private func loadSingleNft(id: String) async -> Nft? {
        isLoading = true
        defer { isLoading = false }
        return try? await nftService.loadNft(id: id)
    }
}
