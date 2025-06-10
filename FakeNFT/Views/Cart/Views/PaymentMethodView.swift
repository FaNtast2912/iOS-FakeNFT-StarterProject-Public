//
//  PaymentMethodView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct PaymentMethodView: View {
    @StateObject private var viewModel: PaymentMethodViewModel
    @EnvironmentObject var navigationModel: NavigationModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(viewModel: PaymentMethodViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            BaseContentView(
                loadingState: viewModel.loadingState,
                loadingMessage: "Загрузка валют...",
                onRetry: { Task { await viewModel.loadData() } }
            ) { currencies in
                if currencies.isEmpty {
                    emptyStateView
                } else {
                    currencyGridView(currencies: currencies)
                }
            }
            
            Spacer()
            paymentBottomView
        }
        .navigationBarBackButtonHidden(true)
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
        .alert("Ошибка оплаты", isPresented: $viewModel.showPaymentError) {
            Button("Повторить") {
                Task {
                    if await viewModel.processPayment() {
                        navigationModel.navigate(to: .paymentDoneView)
                    }
                }
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Не удалось произвести оплату")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                navigationModel.navigateBack()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                    .padding(.leading)
            }
            
            Spacer()
            Text("Выберите способ оплаты")
                .font(.system(size: 17, weight: .semibold))
                .padding(.vertical, 18)
            Spacer()
        }
        .background(Color.white)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Валюты не найдены")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
    }
    
    private func currencyGridView(currencies: [CurrencyModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(currencies) { currency in
                    CurrencyCellView(
                        currency: currency,
                        isSelected: viewModel.selectedCurrency?.id == currency.id
                    )
                    .environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 4)
        }
    }
    
    private var paymentBottomView: some View {
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
                Task {
                    if await viewModel.processPayment() {
                        navigationModel.navigate(to: .paymentDoneView)
                    }
                }
            }) {
                Text("Оплатить")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(viewModel.selectedCurrency != nil ? Color.black : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(viewModel.selectedCurrency == nil || viewModel.loadingState.isLoading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    return PaymentMethodViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
