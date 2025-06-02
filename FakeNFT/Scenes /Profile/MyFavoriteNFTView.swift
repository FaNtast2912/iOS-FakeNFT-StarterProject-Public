//
//  MyFavoriteNFTView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct MyFavoriteNFTView: View {
    @StateObject private var myFavoriteNFTVM: MyFavoriteNFTViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    private let columns = [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)]
    
    init(service: ServicesAssembly) {
        _myFavoriteNFTVM = StateObject(wrappedValue: MyFavoriteNFTViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            VStack {
                if myFavoriteNFTVM.favoriteNfts.isEmpty && myFavoriteNFTVM.loadingState != .loading {
                    EmptyNFTPlaceholderView(isFavoriteCollection: true)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(myFavoriteNFTVM.favoriteNfts, id: \.self) { nft in
                                MyFavoriteNFTCardView(
                                    imageUrl: nft.images.first?.absoluteString ?? "",
                                    name: nft.name,
                                    rating: nft.rating,
                                    price: String(nft.price) + " ETH",
                                    isFavorite: true,
                                    completion: {
                                        Task {
                                            await myFavoriteNFTVM.updateLikesNft(id: nft.id)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .navigationTitle("Избранные NFT")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        navigationModel.navigateBack()
                    } label: {
                        HStack(spacing: 4) {
                            Image("yp.chevron.backward")
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .task {
                await myFavoriteNFTVM.loadLikesNft()
            }
            
            if myFavoriteNFTVM.loadingState == .loading {
                ProgressHUD(isLoading: myFavoriteNFTVM.loadingState == .loading)
            }
        }
    }
}

#Preview {
    MyFavoriteNFTView(service: ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        .environmentObject(NavigationModel())
}
