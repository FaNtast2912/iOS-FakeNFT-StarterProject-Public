//
//  CurrencyCellView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct CurrencyCellView: View {
    let currency: PaymentCrypto
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(currency.icon)
                .resizable()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(currency.title)
                    .font(.system(size: 15, weight: .semibold))
                Text(currency.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.init(red: 0.25, green: 0.87, blue: 0.63))
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color(.black).opacity(0.03), radius: 1)
    }
}

#Preview {
    CurrencyCellView(
        currency: PaymentCrypto(icon: "yp.cripto.bitcoin", title: "Bitcoin", subtitle: "BTC"),
        isSelected: true
    )
}
