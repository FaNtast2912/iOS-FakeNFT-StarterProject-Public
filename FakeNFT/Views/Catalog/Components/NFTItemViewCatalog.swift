//
//  NFTItemViewCatalog.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Ячейка NFT в коллекции
struct NFTItemViewCatalog: View {
    let nft: Nft
    @EnvironmentObject private var cartManager: CartManagerWrapper
    @EnvironmentObject private var likesManager: LikesManagerWrapper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Изображение NFT с кнопкой лайка
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: nft.images.first) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.ypLightGrey)
                        .overlay {
                            ProgressView()
                                .tint(.ypBlueUniversal)
                        }
                }
                .frame(width: 108, height: 108)
                .clipped()
                .cornerRadius(12)
                
                // Кнопка лайка
                Button {
                    likesManager.toggleLike(for: nft.id)
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(likesManager.isLiked(nft.id) ? .ypRedUniversal : .ypWhiteUniversal)
                        .font(.system(size: 14))
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
                .padding(6)
                .disabled(likesManager.isLoading)
            }
            
            // Информация о NFT
            VStack(alignment: .leading) {
                // Рейтинг
                NFTRatingView(rating: nft.rating)
                
                // Цена и кнопка корзины
                HStack {
                    VStack(alignment: .leading) {
                        // Название
                        Text(nft.name)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.ypBlack)
                            .lineLimit(1)
                            .padding(.top, 2)
                        Text("\(nft.price, specifier: "%.2f") ETH")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.ypBlack)
                    }
                    Spacer()
                    
                    Button {
                        cartManager.toggleCart(nft)
                    } label: {
                        Image(cartManager.isInCart(nft) ? .ypCartDelete : .ypCart)
                            .tint(.ypBlack)
                            .font(.system(size: 12))
                    }
                    .disabled(cartManager.isLoading)
                }
            }
            .padding(.top, 8)
        }
        .frame(width: 108, height: 192)
        .opacity((cartManager.isLoading || likesManager.isLoading) ? 0.7 : 1.0)
    }
}

// MARK: - Preview
#Preview {
    let sampleNFT = Nft(
        id: "sample-id",
        name: "Archie",
        createdAt: "2023-06-22T07:37:31.777Z[GMT]",
        images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png")!],
        rating: 4,
        description: "Sample NFT description",
        price: 1.78,
        author: "Sample Author"
    )
    
    let mockNetworkClient = DefaultNetworkClient()
    let mockNftStorage = NftStorageImpl()
    let mockServicesAssembly = ServicesAssembly(networkClient: mockNetworkClient, nftStorage: mockNftStorage)
    
    NFTItemViewCatalog(nft: sampleNFT)
        .environmentObject(mockServicesAssembly.getCartManagerWrapper())
        .environmentObject(mockServicesAssembly.getLikesManagerWrapper())
        .padding()
}
