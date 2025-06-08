//
//  PaymentMethodView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct PaymentMethodView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject private var viewModel: PaymentMethodViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Initialization
    init() {
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        
        self._viewModel = StateObject(wrappedValue: PaymentMethodViewModel(
            cartNetworkService: cartNetworkService
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if viewModel.currencies.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                currencyGridView
            }
            
            Spacer()
            
            paymentBottomView
        }
        .progressHUD(isLoading: viewModel.isLoading)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadCurrencies()
        }
        .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
            Button("Повторить") {
                viewModel.loadCurrencies()
            }
            Button("Отмена", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Не удалось загрузить список валют")
        }
        .alert("Ошибка оплаты", isPresented: $viewModel.showPaymentError) {
            Button("Повторить") {
                Task {
                    print("[PaymentMethodView] Повторная попытка оплаты через alert")
                    if await viewModel.processPayment() {
                        print("[PaymentMethodView] Повторная оплата успешна, переход к PaymentDoneView")
                        navigationModel.navigate(to: .paymentDoneView)
                    } else {
                        print("[PaymentMethodView] Повторная оплата не удалась")
                    }
                }
            }
            Button("Отмена", role: .cancel) {
                print("[PaymentMethodView] Отмена повторной оплаты")
            }
        } message: {
            Text("Не удалось произвести оплату")
        }
    }
    
    // MARK: - Private Views
    
    private var headerView: some View {
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
    
    private var currencyGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.currencies) { currency in
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
                    print("[PaymentMethodView] Нажата кнопка оплаты")
                    print("[PaymentMethodView] Выбранная валюта: \(viewModel.selectedCurrency?.name ?? "nil") (ID: \(viewModel.selectedCurrency?.id ?? "nil"))")
                    print("[PaymentMethodView] Начало процесса оплаты")
                    
                    let paymentResult = await viewModel.processPayment()
                    
                    print("[PaymentMethodView] Результат оплаты: \(paymentResult)")
                    
                    if paymentResult {
                        print("[PaymentMethodView] Платеж успешен, переход к PaymentDoneView")
                        navigationModel.navigate(to: .paymentDoneView)
                    } else {
                        print("[PaymentMethodView] Платеж не удался, остаемся на экране оплаты")
                    }
                }
            }, label: {
                Text("Оплатить")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(viewModel.selectedCurrency != nil ? Color.black : Color.gray)
                    .cornerRadius(12)
            })
            .disabled(viewModel.selectedCurrency == nil || viewModel.isLoading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
}

#Preview("Loading") {
    PaymentMethodView()
        .environmentObject(NavigationModel())
}

#Preview("With Data") {
    PaymentMethodView()
        .environmentObject(NavigationModel())
}
