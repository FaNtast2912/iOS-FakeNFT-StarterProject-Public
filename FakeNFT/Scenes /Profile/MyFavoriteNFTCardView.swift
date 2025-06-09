//
//  MyFavoriteNFTViewCard.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 30.05.2025.
//

import SwiftUI

struct MyFavoriteNFTCardView: View {
    let imageUrl: String
    let name: String
    let rating: Int
    let price: String
    let isFavorite: Bool
    let completion: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.ypLightGrey)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 12))
                Button {
                    completion()
                } label: {
                    Image(isFavorite ? "yp.favorites.active" : "yp.favorites.noActive")
                        .padding(4)
                }
                
            }
            .padding(.trailing, 12)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 17, weight: .bold))
                        .lineLimit(2)
                    HStack(spacing: 0) {
                        ForEach(0..<5) { value in
                            Image(rating > value ? "yp.star.active" : "yp.star.noActive")
                                .padding(.trailing, 2)
                        }
                    }
                }
                
                Text(price)
                    .font(.system(size: 15, weight: .regular))
            }
            .padding(.trailing, 6)
        }
    }
}

#Preview {
    MyFavoriteNFTCardView(
        imageUrl: "https://sun9-71.userapi.com/impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album",
        name: "Archie",
        rating: 3,
        price: "12",
        isFavorite: true,
        completion: { print("tap")}
    )
}
