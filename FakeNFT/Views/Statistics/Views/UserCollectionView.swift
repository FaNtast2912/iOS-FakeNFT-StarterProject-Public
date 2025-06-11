//
//  UserCollectionView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCollectionView: View {
    let user: User
    @StateObject private var viewModel: UserCollectionViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var likesManager: LikesManagerWrapper
    
    init(user: User, viewModel: UserCollectionViewModel) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        BaseContentView(
            loadingState: viewModel.loadingState,
            onRetry: { Task { await viewModel.loadNfts(for: user) } }
        ) { nfts in
            ScrollView {
                LazyVGrid(columns: columns, spacing: AppConstants.UI.defaultSpacing) {
                    ForEach(nfts, id: \.id) { nft in
                        UserCollectionCell(nft: nft)
                    }
                }
            }
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .padding(.top, 20)
        .navigationTitle("Коллекция NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarStyle(dismissAction: {
            navigationModel.navigateBack()
        })
        .task {
            if case .idle = viewModel.loadingState {
                async let loadNfts: Void = viewModel.loadNfts(for: user)
                async let loadLikes: Void = likesManager.loadLikes()
                
                await loadNfts
                await loadLikes
            }
        }
        .refreshable {
            async let refreshNFTs: Void = viewModel.refresh()
            async let refreshLikes: Void = likesManager.loadLikes()
            
            await refreshNFTs
            await refreshLikes
        }
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    let mockUser = User(
        id: "1",
        name: "Mock User",
        avatar: "https://example.com/avatar.jpg",
        description: "Mock user description",
        website: "https://example.com",
        nfts: ["1", "2", "3"],
        rating: "4"
    )
    
    return UserCollectionViewFactory(user: mockUser, servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
