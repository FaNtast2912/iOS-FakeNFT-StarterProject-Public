//
//  LikesManagerWrapper.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 11.06.2025.
//

import SwiftUI
import Foundation

@MainActor
final class LikesManagerWrapper: ObservableObject {
    @Published var likedNFTs: Set<String> = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let likesManager: LikesManager
    private var updateTask: Task<Void, Never>?
    
    init(likesManager: LikesManager) {
        self.likesManager = likesManager
        startPeriodicUpdates()
    }
    
    deinit {
        updateTask?.cancel()
    }
    
    // MARK: - Computed Properties
    
    var likesCount: Int {
        likedNFTs.count
    }
    
    var likedNFTsArray: [String] {
        Array(likedNFTs)
    }
    
    // MARK: - State Checks
    
    func isLiked(_ nft: Nft) -> Bool {
        likedNFTs.contains(nft.id)
    }
    
    func isLiked(_ nftId: String) -> Bool {
        likedNFTs.contains(nftId)
    }
    
    // MARK: - Actions
    
    func toggleLike(for nft: Nft) {
        toggleLike(for: nft.id)
    }
    
    func toggleLike(for nftId: String) {
        guard !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.likesManager.toggleLike(for: nftId)
            }
        }
    }
    
    func addLike(for nft: Nft) {
        addLike(for: nft.id)
    }
    
    func addLike(for nftId: String) {
        guard !isLiked(nftId) && !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.likesManager.addLike(for: nftId)
            }
        }
    }
    
    func removeLike(for nft: Nft) {
        removeLike(for: nft.id)
    }
    
    func removeLike(for nftId: String) {
        guard isLiked(nftId) && !isLoading else { return }
        
        Task {
            await performAction { [weak self] in
                try await self?.likesManager.removeLike(for: nftId)
            }
        }
    }
    
    func loadLikes() {
        Task {
            await performAction { [weak self] in
                try await self?.likesManager.loadLikes()
            }
        }
    }
    
    func refresh() {
        loadLikes()
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
        let newLikedNFTs = await likesManager.getLikedNFTs()
        let newIsLoading = await likesManager.getLoadingState()
        let newError = await likesManager.getError()
        
        likedNFTs = newLikedNFTs
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
    
    // MARK: - Асинхронная версия для особых случаев ;-)

    func toggleLikeAsync(for nft: Nft) async {
        await toggleLikeAsync(for: nft.id)
    }

    func toggleLikeAsync(for nftId: String) async {
        guard !isLoading else { return }
        
        await performAction { [weak self] in
            try await self?.likesManager.toggleLike(for: nftId)
        }
    }
    
}

// MARK: - ServicesAssembly Extension

extension ServicesAssembly {
    // Ленивая инициализация оберток
    private var _cartManagerWrapper: CartManagerWrapper? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cartManagerWrapper) as? CartManagerWrapper
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cartManagerWrapper, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var _likesManagerWrapper: LikesManagerWrapper? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.likesManagerWrapper) as? LikesManagerWrapper
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.likesManagerWrapper, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Получить или создать обертку для CartManager (singleton per ServicesAssembly)
    func getCartManagerWrapper() -> CartManagerWrapper {
        if let wrapper = _cartManagerWrapper {
            return wrapper
        }
        
        let wrapper = CartManagerWrapper(cartManager: cartManager)
        _cartManagerWrapper = wrapper
        return wrapper
    }
    
    /// Получить или создать обертку для LikesManager (singleton per ServicesAssembly)
    func getLikesManagerWrapper() -> LikesManagerWrapper {
        if let wrapper = _likesManagerWrapper {
            return wrapper
        }
        
        let wrapper = LikesManagerWrapper(likesManager: likesManager)
        _likesManagerWrapper = wrapper
        return wrapper
    }
}

// MARK: - Associated Objects Keys

private struct AssociatedKeys {
    static var cartManagerWrapper: UInt8 = 0
    static var likesManagerWrapper: UInt8 = 0
}
