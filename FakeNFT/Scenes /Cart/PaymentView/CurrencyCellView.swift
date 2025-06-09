//
//  CurrencyCellView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct CurrencyCellView: View {
    @EnvironmentObject var viewModel: PaymentMethodViewModel
    
    let currency: CurrencyModel
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: currency.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.7)
                    )
            }
            .frame(width: 36, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(currency.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(currency.code)
                    .font(.system(size: 13))
                    .foregroundColor(.init(red: 0.25, green: 0.87, blue: 0.63))
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black : Color.clear, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color(.black).opacity(0.03), radius: 1)
        .onTapGesture {
            if isSelected {
                viewModel.selectedCurrency = nil
                print("Deselected currency: \(currency.name) (\(currency.code))")
            } else {
                viewModel.selectedCurrency = currency
                print("Selected currency: \(currency.name) (\(currency.code))")
            }
        }
    }
}

#Preview {
    CurrencyCellView(
        currency: CurrencyModel(
            id: "1",
            name: "Bitcoin",
            title: "BTC",
            image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png"
        ),
        isSelected: true
    )
    .environmentObject({
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        return PaymentMethodViewModel(cartNetworkService: cartNetworkService)
    }())
}

#Preview("Not Selected") {
    CurrencyCellView(
        currency: CurrencyModel(
            id: "2",
            name: "Ethereum",
            title: "ETH",
            image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Ethereum_(ETH).png"
        ),
        isSelected: false
    )
    .environmentObject({
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        return PaymentMethodViewModel(cartNetworkService: cartNetworkService)
    }())
}
