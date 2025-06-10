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

//Макс, не забудь!
//#Preview {
//    UserCollectionView(
//        user: User(
//            id: "1",
//            name: "Mock User",
//            avatar: "",
//            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
//            website: "https://example.com",
//            nfts: ["a", "c", "c", "a", "d"],
//            rating: "3"
//        ),
//        nftService: MockUserCollectionService()
//    )
//}
