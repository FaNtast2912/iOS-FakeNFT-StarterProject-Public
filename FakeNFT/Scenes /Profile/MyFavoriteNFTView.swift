//
//  MyFavoriteNFTView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct MyFavoriteNFTView: View {
    @StateObject private var myFavoriteNFTVM = MyFavoriteNFTViewModel()
    @EnvironmentObject private var navigationModel: NavigationModel
    
    private let columns = [GridItem(.flexible(), spacing: 7), GridItem(.flexible(), spacing: 7)]
    
    var body: some View {
        VStack {
            if myFavoriteNFTVM.favoriteNfts.isEmpty {
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
                                completion: { print("like tapped") }
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
    }
}

#Preview {
    MyFavoriteNFTView()
        .environmentObject(NavigationModel())
}
