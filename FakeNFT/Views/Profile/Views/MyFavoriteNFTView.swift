//
//  MyFavoriteNFTView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct MyFavoriteNFTView: View {
    @StateObject private var viewModel: MyFavoriteNFTViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var likesManager: LikesManagerWrapper
    
    private let columns = [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)]
    
    init(viewModel: MyFavoriteNFTViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BaseContentView(
                loadingState: viewModel.loadingState,
                loadingMessage: "Загрузка избранных NFT...",
                onRetry: { Task { await viewModel.loadData() } }
            ) { nfts in
                if nfts.isEmpty {
                    EmptyNFTPlaceholderView(isFavoriteCollection: true)
                } else {
                    favoriteNftsGrid(nfts: nfts)
                }
            }
        }
        .navigationTitle("Избранные NFT")
        .navigationBarStyle {
            navigationModel.navigateBack()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 20)
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
        .refreshable {
            async let refreshData: Void = viewModel.refresh()
            async let refreshLikes: Void = likesManager.loadLikes()
            
            await refreshData
            await refreshLikes
        }
    }
    
    private func favoriteNftsGrid(nfts: [Nft]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(nfts, id: \.id) { nft in
                    MyFavoriteNFTCardView(
                        imageUrl: nft.images.first?.absoluteString ?? "",
                        name: nft.name,
                        rating: nft.rating,
                        price: String(nft.price) + " ETH",
                        isFavorite: likesManager.isLiked(nft)
                    ) {
                        Task {
                            await likesManager.removeLike(for: nft)
                            await viewModel.loadData() // Перезагрузить список
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    return MyFavoriteNFTViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
