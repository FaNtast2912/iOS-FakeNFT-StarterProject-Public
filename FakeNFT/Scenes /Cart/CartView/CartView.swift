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

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    // action
                }, label: {
                    Image("yp.sort")
                        .resizable()
                        .frame(width: 32, height: 24)
                        .foregroundColor(.black)
                        .padding(.trailing, 9)
                })
            }

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(mockData.cartNFTs) { nft in
                        NFTItemView(nft: nft)
                    }
                }
                .padding(.top, 36)
                .padding(.horizontal, 16)
            }

            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 76)
                    .cornerRadius(12)

                HStack {
                    VStack(alignment: .leading) {
                        Text("\(mockData.nftCount) NFT")
                            .font(.system(size: 15, weight: .regular))
                            .padding(.bottom, 2)

                        Text(String(format: "%.2f ETH", mockData.totalCostNft))
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.ypGreenUniversal)
                    }

                    Spacer()

                    Button(action: {
                        navigation.navigate(to: .paymentMethodView)
                        print("tap")
                    }, label: {
                        Text("К оплате")
                            .frame(width: 240, height: 44)
                            .font(.system(size: 17, weight: .bold))
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    })
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(NavigationModel())
        .environmentObject(MockData())
}
