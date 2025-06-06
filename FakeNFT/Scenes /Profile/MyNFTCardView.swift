//
//  MyNFTCardView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 04.06.2025.
//

import SwiftUI

struct MyNFTCardView: View {
    let imageUrl: String
    let name: String
    let rating: Int
    let price: String
    let isFavorite: Bool
    let author: String
    let completion: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .image?.resizable()
                        .frame(width: 108, height: 108)
                        .clipShape(.rect(cornerRadius: 12))
                        .aspectRatio(contentMode: .fit)
                }
                Button {
                    completion()
                } label: {
                    Image(isFavorite ? "yp.favorites.active" : "yp.favorites.noActive")
                        .padding(12)
                }
            }
            .padding(.trailing, 12)
            
            HStack(spacing: 39) {
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
                    Text("от \(author.correctAuthorName(with: "https://", ending: ".fakenfts.org/"))")
                        .font(.system(size: 13, weight: .regular))
                        .lineLimit(3)
                }
                .frame(width: 78)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(.system(size: 13, weight: .regular))
                    Text(price)
                        .font(.system(size: 17, weight: .bold))
                }
                
            }
        }
        .padding(.vertical, 16)
        
    }
}

#Preview {
    MyNFTCardView(imageUrl: "https://sun9-71.userapi.com/impf/HXh-XOzRZNjBZN3-s3KY8-A1vvUZcCzEIVCO7A/NiLsvqlmqpI.jpg?size=320x256&quality=96&sign=cae1cfe812481cab04191c25a4dda9c4&type=album",
                  name: "Archie",
                  rating: 3,
                  price: "12",
                  isFavorite: true,
                  author: "Cat",
                  completion: {print("tap")}
    )
}
