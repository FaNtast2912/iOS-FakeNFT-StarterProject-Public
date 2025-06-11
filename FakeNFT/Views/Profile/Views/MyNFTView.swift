//
//  MyNFTView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import SwiftUI

struct MyNFTView: View {
    @StateObject private var viewModel: MyNFTViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var likesManager: LikesManagerWrapper
    
    init(viewModel: MyNFTViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BaseContentView(
                loadingState: viewModel.loadingState,
                onRetry: { Task { await viewModel.loadData() } }
            ) { _ in
                if viewModel.sortedNfts.isEmpty {
                    EmptyNFTPlaceholderView(isFavoriteCollection: false)
                } else {
                    nftListContent
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Мои NFT")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigationModel.navigateBack()
                } label: {
                    Image(.ypChevronBackward)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.ypBlack)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showConfirmationDialog = true
                } label: {
                    Image(.ypSort)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.ypBlack)
                }
            }
        }
        .confirmationDialog("Сортировка", isPresented: $viewModel.showConfirmationDialog, titleVisibility: .visible) {
            Button("По цене") {
                viewModel.setSortOption(.nftPrice(ascending: true))
            }
            Button("По рейтингу") {
                viewModel.setSortOption(.nftRating(ascending: true))
            }
            Button("По названию") {
                viewModel.setSortOption(.nftName(ascending: true))
            }
            Button("Закрыть", role: .cancel) {}
        }
        .task {
            if case .idle = viewModel.loadingState {
                viewModel.setLoading()
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
    
    private var nftListContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.sortedNfts, id: \.id) { nft in
                    MyNFTCardView(
                        imageUrl: nft.images.first?.absoluteString ?? "",
                        name: nft.name,
                        rating: nft.rating,
                        price: String(nft.price) + " ETH",
                        isFavorite: likesManager.isLiked(nft),
                        author: nft.author
                    ) {
                        Task {
                            await likesManager.toggleLike(for: nft)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .scrollIndicators(.hidden)
    }
}
