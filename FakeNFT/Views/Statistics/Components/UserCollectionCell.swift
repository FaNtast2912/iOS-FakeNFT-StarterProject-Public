import SwiftUI

struct UserCollectionCell: View {
    let nft: Nft
    @EnvironmentObject private var cartManager: CartManager
    @EnvironmentObject private var likesManager: LikesManager
    
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
            AsyncImage(url: nft.images.first) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Color.ypLightGrey)
                    .overlay {
                        ProgressHUD(isLoading: true)
                    }
            }
            .frame(width: 108, height: 108)
            .cornerRadius(AppConstants.UI.defaultCornerRadius)
            
            Button {
                likesManager.toggleLike(for: nft.id)
            } label: {
                Image(likesManager.isLiked(nft.id) ? .ypFavoritesActive : .ypFavoritesNoActive)
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .padding(8)
            
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
            
            Button {
                if cartManager.isInCart(nft) {
                    cartManager.removeFromCart(nft)
                } else {
                    cartManager.addToCart(nft)
                }
            } label: {
                Image(cartManager.isInCart(nft) ? .ypCartDelete : .ypCart)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .frame(alignment: .center)
        
    }
}

#Preview {
    let mockNft = Nft(
            id: "a",
            name: "hjgguy dgbfdb",
            createdAt: "897 79",
            images: [],
            rating: 3,
            description: "ggvhhijoj hbhjokpo huhijpoklm",
            price: 14.98,
            author: ""
        )
    let mockNetworkClient = DefaultNetworkClient()
    let mockNftStorage = NftStorageImpl()
    let mockServicesAssembly = ServicesAssembly(networkClient: mockNetworkClient, nftStorage: mockNftStorage)
    UserCollectionCell(nft: mockNft)
        .environmentObject(mockServicesAssembly.cartManager)
        .environmentObject(mockServicesAssembly.likesManager)
    
}
