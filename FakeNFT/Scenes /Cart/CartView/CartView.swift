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
            HStack {
                Spacer()
                Button(
                    action: { showSortOptions.toggle() },
                    label: {
                        Image("yp.sort")
                            .resizable()
                            .frame(width: 21, height: 12.6)
                            .foregroundColor(.black)
                            .padding(.trailing, 19.5)
                    }
                )
                .confirmationDialog(
                    "Сортировка",
                    isPresented: $showSortOptions,
                    actions: {
                        Button(
                            action: { currentSortOption = .price },
                            label: { Text("По цене") }
                        )
                        Button(
                            action: { currentSortOption = .rating },
                            label: { Text("По рейтингу") }
                        )
                        Button(
                            action: { currentSortOption = .name },
                            label: { Text("По названию") }
                        )
                        Button(
                            role: .cancel,
                            action: {},
                            label: { Text("Закрыть") }
                        )
                    }
                )
            }
            .padding(.top, 16)

            if mockData.nfts.isEmpty {
                Spacer()
                Text("Корзина пуста")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.ypBlackUniversal)

                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sortedNFTs, id: \.id) { nft in
                            NFTItemView(nft: nft, showDeleteConfirmation: $showDeleteConfirmation)
                        }
                    }
                    .padding(.top, 36)
                    .padding(.horizontal, 16)
                }
            }

            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 76)
                    .cornerRadius(12)

                HStack {
                    VStack(alignment: .leading) {
                        Text("\(mockData.nfts.count) NFT")
                            .font(.system(size: 15, weight: .regular))
                            .padding(.bottom, 2)

                        Text(String(format: "%.2f ETH", mockData.nfts.reduce(0) { $0 + $1.price }))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.ypGreenUniversal)
                    }
                    
                    Spacer()
                    
                    Button(
                        action: { navigation.navigate(to: .paymentMethodView) },
                        label: {
                            Text("К оплате")
                                .frame(width: 240, height: 44)
                                .font(.system(size: 17, weight: .bold))
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .overlay(
            Group {
                if showDeleteConfirmation {
                    DeleteNFTConfirmationView(
                        nftImage: Image("mockImageNFT"),
                        onDelete: { showDeleteConfirmation = false },
                        onCancel: { showDeleteConfirmation = false }
                    )
                }
            }
        )
    }
}

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
