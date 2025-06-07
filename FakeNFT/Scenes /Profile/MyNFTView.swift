//
//  MyNFTView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import SwiftUI

struct MyNFTView: View {
    @StateObject private var myNFTVM: MyNFTViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    init(service: ServicesAssembly) {
        _myNFTVM = StateObject(wrappedValue: MyNFTViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            VStack {
                if myNFTVM.nfts.isEmpty && myNFTVM.loadingState != .loading {
                    EmptyNFTPlaceholderView(isFavoriteCollection: false)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(myNFTVM.sortedNfts, id: \.self) { nft in
                                MyNFTCardView(
                                    imageUrl: nft.images.first?.absoluteString ?? "",
                                    name: nft.name,
                                    rating: nft.rating,
                                    price: String(nft.price) + " ETH",
                                    isFavorite: myNFTVM.isLiked(id: nft.id),
                                    author: nft.author) {
                                        Task {
                                           await myNFTVM.setNftLike(id: nft.id)
                                        }
                                }
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await myNFTVM.fetchNfts(.loaded)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationModel.navigateBack()
                    } label: {
                        Image(.ypChevronBackward)
                            .frame(width: 24, height: 24)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        myNFTVM.showConfirmationDialog = true
                    } label: {
                        Image(.ypSort)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .navigationTitle("Мои NFT")
            .confirmationDialog("Сортировка", isPresented: $myNFTVM.showConfirmationDialog, titleVisibility: .visible) {
                Button("По цене") { myNFTVM.setFilter(by: .price) }
                Button("По рейтингу") { myNFTVM.setFilter(by: .rating) }
                Button("По названию") { myNFTVM.setFilter(by: .name) }
                Button("Закрыть", role: .cancel) { }
            }
            .task {
                await myNFTVM.fetchNfts()
            }
            .progressHUD(isLoading: myNFTVM.loadingState == .loading)
            
        }
    }
}

#Preview {
    MyNFTView(service: ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
