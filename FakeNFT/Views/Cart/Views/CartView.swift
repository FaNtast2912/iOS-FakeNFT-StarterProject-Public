//
//  CartView.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel: CartViewModel
    @EnvironmentObject var navigation: NavigationModel
    @EnvironmentObject private var cartManager: CartManagerWrapper
    
    @State private var showDeleteConfirmation = false
    @State private var nftToDelete: Nft?
    @State private var showSortOptions = false
    
    init(viewModel: CartViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            sortButton
            if cartManager.isLoading && cartManager.items.isEmpty {
                VStack {
                    Spacer()
                    ProgressView("Загрузка корзины...")
                        .font(.system(size: 17, weight: .medium))
                    Spacer()
                }
            } else if let error = cartManager.error {
                VStack {
                    Spacer()
                    Text("Ошибка загрузки")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.bottom, 8)
                    Text(error.localizedDescription)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                    Button("Повторить") {
                        cartManager.refresh()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer()
                }
            } else if cartManager.items.isEmpty {
                emptyCartView
            } else {
                nftListView(nfts: cartManager.items)
            }
            
            paymentSummaryView
        }
        .progressHUD(isLoading: cartManager.isLoading || viewModel.isDeleting)
        .overlay(deleteConfirmationOverlay)
        .task {
            // Загружаем данные только при первом запуске, если корзина пуста
            if cartManager.items.isEmpty && !cartManager.isLoading {
                cartManager.loadCart()
            }
        }
        .refreshable {
            // Pull-to-refresh для ручного обновления
            cartManager.refresh()
        }
        .alert("Ошибка", isPresented: .constant(cartManager.error != nil)) {
            Button("Повторить") {
                cartManager.refresh()
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text(cartManager.error?.localizedDescription ?? "Произошла ошибка")
        }
    }
    
    private var sortButton: some View {
        HStack {
            Spacer()
            Button(action: { showSortOptions.toggle() }) {
                Image("yp.sort")
                    .resizable()
                    .frame(width: 21, height: 12.6)
                    .foregroundColor(.black)
                    .padding(.trailing, 19.5)
            }
            .disabled(cartManager.isLoading || viewModel.isDeleting)
            .confirmationDialog("Сортировка", isPresented: $showSortOptions) {
                ForEach(CartViewModel.SortOption.allCases, id: \.self) { option in
                    Button(option.rawValue) {
                        viewModel.currentSortOption = option
                    }
                }
                Button("Закрыть", role: .cancel) {}
            }
        }
        .padding(.top, 16)
    }
    
    private var emptyCartView: some View {
        VStack {
            Spacer()
            Text("Корзина пуста")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.ypBlackUniversal)
            Spacer()
        }
    }
    
    private func nftListView(nfts: [Nft]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(getSortedNFTs(from: nfts), id: \.id) { nft in
                    NFTItemView(
                        nft: nft,
                        onDeleteTap: {
                            nftToDelete = nft
                            showDeleteConfirmation = true
                        }
                    )
                    .disabled(viewModel.isDeleting || cartManager.isLoading)
                    .opacity((viewModel.isDeleting || cartManager.isLoading) ? 0.6 : 1.0)
                }
            }
            .padding(.top, 36)
            .padding(.horizontal, AppConstants.UI.defaultPadding)
        }
    }
    
    /// Получить отсортированные NFT из CartManager
    private func getSortedNFTs(from nfts: [Nft]) -> [Nft] {
        let unifiedOption = viewModel.currentSortOption.toUnifiedSortOption()
        return UnifiedSortingManager.shared.sort(items: nfts, by: unifiedOption) as? [Nft] ?? nfts
    }
    
    private var paymentSummaryView: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray6))
                .frame(height: 76)
                .cornerRadius(12)
            
            HStack {
                VStack(alignment: .leading) {
                    // Используем cartManager для получения актуального количества
                    Text("\(cartManager.itemsCount) NFT")
                        .font(.system(size: 15, weight: .regular))
                        .padding(.bottom, 2)
                    
                    // Используем cartManager для получения актуальной суммы
                    Text(String(format: "%.2f ETH", cartManager.totalPrice))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.ypGreenUniversal)
                }
                
                Spacer()
                
                Button(action: {
                    navigation.navigate(to: .paymentMethodView)
                }) {
                    Text("К оплате")
                        .frame(width: 240, height: 44)
                        .font(.system(size: 17, weight: .bold))
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .disabled(cartManager.isEmpty || cartManager.isLoading || viewModel.isDeleting)
                .opacity((cartManager.isEmpty || cartManager.isLoading || viewModel.isDeleting) ? 0.6 : 1.0)
            }
            .padding(.horizontal, AppConstants.UI.defaultPadding)
        }
    }
    
    private var deleteConfirmationOverlay: some View {
        Group {
            if showDeleteConfirmation, let nft = nftToDelete {
                DeleteNFTConfirmationView(
                    nftImage: Image("mockImageNFT"),
                    onDelete: {
                        Task {
                            // Используем только CartManager для удаления
                            cartManager.removeFromCart(nft)
                        }
                        showDeleteConfirmation = false
                        nftToDelete = nil
                    },
                    onCancel: {
                        showDeleteConfirmation = false
                        nftToDelete = nil
                    }
                )
            }
        }
    }
}

#Preview("With Items") {
    let mockServices = MockServicesAssembly()
    return CartViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}

#Preview("Empty Cart") {
    let mockServices = MockServicesAssembly()
    return CartViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
