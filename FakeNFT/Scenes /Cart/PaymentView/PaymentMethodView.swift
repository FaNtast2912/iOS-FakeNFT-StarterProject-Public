//
//  PaymentMethodView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct PaymentMethodView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @EnvironmentObject var mockData: MockData
    @EnvironmentObject var viewModel: PaymentMethodViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    navigationModel.navigateBack()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .padding(.leading)
                })
                
                Spacer()
                Text("Выберите способ оплаты")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.vertical, 18)
                Spacer()
            }
            .background(Color.white)
            
            // Сетка криптовалют
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.currencies) { crypto in
                    CurrencyCellView(
                        currency: crypto,
                        isSelected: viewModel.selectedCurrency?.id == crypto.id
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 4)
            
            Spacer()
            
            // Соглашение + кнопка
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("Совершая покупку, вы соглашаетесь с условиями")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text("Пользовательского соглашения")
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                        .underline()
                        .onTapGesture {
                            navigationModel.openPracticumTerms()
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    navigationModel.navigate(to: .paymentDoneView)
                }, label: {
                    Text("Оплатить")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.black)
                        .cornerRadius(12)
                })
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PaymentMethodView()
        .environmentObject(NavigationModel())
        .environmentObject(MockData())
        .environmentObject(PaymentMethodViewModel())
}
