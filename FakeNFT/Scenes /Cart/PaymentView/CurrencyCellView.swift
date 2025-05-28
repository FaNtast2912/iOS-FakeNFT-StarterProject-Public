//
//  CurrencyCellView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct CurrencyCellView: View {
    let currency: CurrencyModel
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(currency.iconName)
                .resizable()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(currency.name)
                    .font(.subheadline)
                Text(currency.code)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding()
        .background(isSelected ? Color(.systemGray5) : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    CurrencyCellView(currency: CurrencyModel(name: "Bitcoin", code: "BTC", iconName: "btc"), isSelected: true)
}
