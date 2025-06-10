//
//  UserCollectionView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCollectionView: View {
    @StateObject private var viewModel: UserCollectionViewModel
    @EnvironmentObject var navigationModel: NavigationModel
    
    let user: User
    
    init(user: User, nftService: NftServiceProtocol) {
        _viewModel = StateObject(wrappedValue: UserCollectionViewModel(nftService: nftService))
        self.user = user
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(user.nfts, id: \.self) { nftId in
                    if let nft = viewModel.nfts.first(where: { $0.id == nftId }) {
                        UserCollectionCell(nft: nft)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .navigationTitle("Коллекция NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarStyle(dismissAction: {
            navigationModel.navigateBack()
        })
        .progressHUD(isLoading: viewModel.isLoading)
        .task {
            await viewModel.loadNfts(for: user)
        }
    }
}

#Preview {
    UserCollectionView(
        user: User(
            id: "1",
            name: "Mock User",
            avatar: "",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "https://example.com",
            nfts: ["a", "c", "c", "a", "d"],
            rating: "3"
        ),
        nftService: MockUserCollectionService()
    )
}
