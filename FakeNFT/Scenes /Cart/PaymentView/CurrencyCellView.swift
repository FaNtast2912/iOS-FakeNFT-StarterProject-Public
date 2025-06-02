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
            Image(currency.iconName) // Используем computed property iconName
                .resizable()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(currency.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(currency.code) // Используем computed property code
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
            viewModel.selectedCurrency = currency
            print("Selected currency: \(currency.name) (\(currency.code))")
        }
    }
}

#Preview {
    CurrencyCellView(
        currency: CurrencyModel(
            id: "1",
            name: "Bitcoin",
            title: "BTC",
            image: "yp.cripto.bitcoin" // Теперь используем новые параметры
        ),
        isSelected: true
    )
    .environmentObject(PaymentMethodViewModel())
}
