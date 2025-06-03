//
//  NFTItemView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 30.05.2025.
//

import SwiftUI

/// Ячейка NFT в коллекции
struct NFTItemView: View {
    let nft: Nft
    @State private var isLiked = false
    @State private var isInCart = false
    
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
                    isLiked.toggle()
                } label: {
                    Image(systemName:"heart.fill")
                        .foregroundColor(isLiked ? .ypRedUniversal : .ypWhiteUniversal)
                        .font(.system(size: 14))
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
                .padding(6)
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
                            .foregroundColor(.ypBlackUniversal)
                            .lineLimit(1)
                            .padding(.top, 2)
                        Text("\(nft.price, specifier: "%.2f") ETH")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.ypBlackUniversal)
                        
                    }
                    Spacer()
                    
                    Button {
                        isInCart.toggle()
                    } label: {
                        Image(isInCart ? "yp.cart.delete" : "yp.cart")
                            .foregroundColor(.ypBlackUniversal)
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(.top, 8)
        }
        .frame(width: 108, height: 192)
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
    
    NFTItemView(nft: sampleNFT)
        .padding()
        .previewLayout(.sizeThatFits)
}
