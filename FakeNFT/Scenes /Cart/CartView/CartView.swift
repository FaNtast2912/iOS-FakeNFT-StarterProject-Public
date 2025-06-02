//
//  CartView.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var mockData: MockData
    @EnvironmentObject var navigation: NavigationModel
    
    @State private var showDeleteConfirmation = false
    @State private var showSortOptions = false
    @State private var currentSortOption: SortOption = .price
    
    private enum Constants {
        static let sortButtonImageSize: CGFloat = 21
        static let sortButtonImageHeight: CGFloat = 12.6
        static let sortButtonTrailingPadding: CGFloat = 19.5
        static let emptyCartFontSize: CGFloat = 17
        static let nftListTopPadding: CGFloat = 36
        static let nftListHorizontalPadding: CGFloat = 16
        static let nftListSpacing: CGFloat = 16
        static let paymentSummaryHeight: CGFloat = 76
        static let paymentSummaryCornerRadius: CGFloat = 12
        static let paymentSummaryHorizontalPadding: CGFloat = 16
        static let nftCountFontSize: CGFloat = 15
        static let priceFontSize: CGFloat = 17
        static let payButtonWidth: CGFloat = 240
        static let payButtonHeight: CGFloat = 44
        static let payButtonCornerRadius: CGFloat = 16
    }
    
    private enum SortOption: String {
        case price = "По цене"
        case rating = "По рейтингу"
        case name = "По названию"
        
        func toProductSortOption() -> ProductSortOption {
            switch self {
            case .price: return .price(ascending: true)
            case .rating: return .rating(ascending: true)
            case .name: return .name(ascending: true)
            }
        }
    }
    
    private var sortedNFTs: [Nft] {
        let option = currentSortOption.toProductSortOption()
        return SortingManager.shared.sort(products: mockData.nfts, by: option)
    }

    var body: some View {
        VStack(spacing: 0) {
            sortButton
            
            if mockData.nfts.isEmpty {
                emptyCartView
            } else {
                nftListView
            }
            
            paymentSummaryView
        }
        .overlay(deleteConfirmationOverlay)
    }
    
    // MARK: - Private Subviews
    
    private var sortButton: some View {
        HStack {
            Spacer()
            Button(
                action: { showSortOptions.toggle() },
                label: {
                    Image("yp.sort")
                        .resizable()
                        .frame(width: Constants.sortButtonImageSize, height: Constants.sortButtonImageHeight)
                        .foregroundColor(.black)
                        .padding(.trailing, Constants.sortButtonTrailingPadding)
                }
            )
            .confirmationDialog(
                "Сортировка",
                isPresented: $showSortOptions,
                actions: {
                    ForEach([SortOption.price, .rating, .name], id: \.self) { option in
                        Button(option.rawValue) { currentSortOption = option }
                    }
                    Button("Закрыть", role: .cancel) {}
                }
            )
        }
        .padding(.top, 16)
    }
    
    private var emptyCartView: some View {
        VStack {
            Spacer()
            Text("Корзина пуста")
                .font(.system(size: Constants.emptyCartFontSize, weight: .bold))
                .foregroundColor(.ypBlackUniversal)
            Spacer()
        }
    }
    
    private var nftListView: some View {
        ScrollView {
            LazyVStack(spacing: Constants.nftListSpacing) {
                ForEach(sortedNFTs, id: \.id) { nft in
                    NFTItemView(nft: nft, showDeleteConfirmation: $showDeleteConfirmation)
                }
            }
            .padding(.top, Constants.nftListTopPadding)
            .padding(.horizontal, Constants.nftListHorizontalPadding)
        }
    }
    
    private var paymentSummaryView: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray6))
                .frame(height: Constants.paymentSummaryHeight)
                .cornerRadius(Constants.paymentSummaryCornerRadius)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(mockData.nfts.count) NFT")
                        .font(.system(size: Constants.nftCountFontSize, weight: .regular))
                        .padding(.bottom, 2)
                    
                    Text(String(format: "%.2f ETH", mockData.nfts.reduce(0) { $0 + $1.price }))
                        .font(.system(size: Constants.priceFontSize, weight: .bold))
                        .foregroundColor(.ypGreenUniversal)
                }
                
                Spacer()
                
                payButton
            }
            .padding(.horizontal, Constants.paymentSummaryHorizontalPadding)
        }
    }
    
    private var payButton: some View {
        Button(
            action: { navigation.navigate(to: .paymentMethodView) },
            label: {
                Text("К оплате")
                    .frame(width: Constants.payButtonWidth, height: Constants.payButtonHeight)
                    .font(.system(size: Constants.priceFontSize, weight: .bold))
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.payButtonCornerRadius)
            }
        )
    }
    
    private var deleteConfirmationOverlay: some View {
        Group {
            if showDeleteConfirmation {
                DeleteNFTConfirmationView(
                    nftImage: Image("mockImageNFT"),
                    onDelete: { showDeleteConfirmation = false },
                    onCancel: { showDeleteConfirmation = false }
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let mockData = MockData()
    mockData.nfts = [
        Nft(
            id: "0",
            name: "NFT 1",
            createdAt: "",
            images: [],
            rating: 3,
            description: "",
            price: 1.5,
            author: ""
        ),
        Nft(
            id: "1",
            name: "NFT 2",
            createdAt: "",
            images: [],
            rating: 4,
            description: "",
            price: 2.3,
            author: ""
        ),
        Nft(
            id: "2",
            name: "NFT 3",
            createdAt: "",
            images: [],
            rating: 5,
            description: "",
            price: 3.1,
            author: ""
        )
    ]
    
    return CartView()
        .environmentObject(NavigationModel())
        .environmentObject(mockData)
}
