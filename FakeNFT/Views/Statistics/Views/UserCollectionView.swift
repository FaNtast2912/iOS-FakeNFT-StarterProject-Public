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
    
    init(user: User, viewModel: UserCollectionViewModel) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseContentView(
            loadingState: viewModel.loadingState,
            onRetry: { Task { await viewModel.loadNfts(for: user) } }
        ) { nfts in
            ScrollView {
                LazyVStack {
                    ForEach(nfts, id: \.id) { nft in
                        // NFT card view
                        Text(nft.name)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("\(user.name)'s Collection")
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadNfts(for: user)
            }
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
