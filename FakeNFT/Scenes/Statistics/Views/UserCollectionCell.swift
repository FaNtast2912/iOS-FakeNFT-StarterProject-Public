import SwiftUI

struct UserCollectionCell: View {
    let nft: Nft

    var body: some View {
        contentView
            .foregroundStyle(Color.ypBlack)
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .leading) {
            nftImageView
            nftRatingView
            nftDetailsView
            Spacer()
        }
        .frame(width: 108, height: 192)
    }

    private var nftImageView: some View {
        ZStack(alignment: .topTrailing) {
            Image("yp.mockNFTImg")
                .resizable()
                .frame(width: 108, height: 108)
                .cornerRadius(12)
            
            Image("yp.favorites.noActive")
                .frame(width: 40, height: 40)
            
        }
    }

    private var nftRatingView: some View {
        HStack(spacing: 3) {
            ForEach(1..<6) { index in
                Image(index <= nft.rating ? "yp.star.active" : "yp.star.noActive")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
    }

    private var nftDetailsView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.bottom, 4)
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.system(size: 10, weight: .medium))
                  
            }
            Spacer()
            Image("yp.cart")
                .frame(width: 40, height: 40)
           
        }
        .frame(alignment: .center)
        
    }
}

#Preview {
    UserCollectionCell(
        nft: Nft(
            id: "a",
            name: "hjgguy dgbfdb",
            createdAt: "897 79",
            images: [],
            rating: 3,
            description: "ggvhhijoj hbhjokpo huhijpoklm",
            price: 14.98,
            author: ""
        )
    )
}
