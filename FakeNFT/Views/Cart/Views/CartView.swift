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
    
    // Доступные опции сортировки для корзины
    private let sortOptions: [UnifiedSortOption] = [
        .nftPrice(ascending: false),
        .nftRating(ascending: false),
        .nftName(ascending: false),
    ]
    
    init(viewModel: CartViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            sortButton
            if viewModel.isLoading && viewModel.nfts.isEmpty {
                VStack {
                    Spacer()
                    ProgressView("Загрузка корзины...")
                        .font(.system(size: 17, weight: .medium))
                    Spacer()
                }
            } else if let error = viewModel.error {
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
                        Task {
                            await viewModel.loadData()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer()
                }
            } else if viewModel.nfts.isEmpty {
                emptyCartView
            } else {
                nftListView
            }
            
            paymentSummaryView
        }
        .progressHUD(isLoading: viewModel.isLoading || viewModel.isDeleting)
        .overlay(deleteConfirmationOverlay)
        .task {
            // Загружаем данные только при первом запуске, если корзина пуста
            if viewModel.nfts.isEmpty && !viewModel.isLoading {
                await viewModel.loadData()
            }
        }
        .refreshable {
            // Pull-to-refresh для ручного обновления
            await viewModel.refresh()
        }
        .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
            Button("Повторить") {
                Task {
                    await viewModel.refresh()
                }
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Произошла ошибка")
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
            .disabled(viewModel.isLoading || viewModel.isDeleting)
            .confirmationDialog("Сортировка", isPresented: $showSortOptions) {
                ForEach(sortOptions, id: \.description) { option in
                    Button(getSortOptionTitle(option)) {
                        viewModel.setSortOption(option)
                    }
                }
                Button("Закрыть", role: .cancel) {}
            }
        }
        .padding(.top, 16)
    }
    
    private func getSortOptionTitle(_ option: UnifiedSortOption) -> String {
        switch option {
        case .nftPrice(let ascending):
            return ascending ? "По цене" : "По цене"
        case .nftRating(let ascending):
            return ascending ? "По рейтингу" : "По рейтингу"
        case .nftName(let ascending):
            return ascending ? "По названию" : "По названию"
        default:
            return "Неизвестно"
        }
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
    
    private var nftListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedNfts, id: \.id) { nft in
                    NFTItemView(
                        nft: nft,
                        onDeleteTap: {
                            nftToDelete = nft
                            showDeleteConfirmation = true
                        }
                    )
                    .disabled(viewModel.isDeleting || viewModel.isLoading)
                    .opacity((viewModel.isDeleting || viewModel.isLoading) ? 0.6 : 1.0)
                }
            }
            .padding(.top, 36)
            .padding(.horizontal, AppConstants.UI.defaultPadding)
        }
    }
    
    private var paymentSummaryView: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray6))
                .frame(height: 76)
                .cornerRadius(12)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(viewModel.nfts.count) NFT")
                        .font(.system(size: 15, weight: .regular))
                        .padding(.bottom, 2)
                    
                    Text(viewModel.formattedTotalPrice)
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
                .disabled(viewModel.nfts.isEmpty || viewModel.isLoading || viewModel.isDeleting)
                .opacity((viewModel.nfts.isEmpty || viewModel.isLoading || viewModel.isDeleting) ? 0.6 : 1.0)
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
                            await viewModel.deleteNFT(nft.id)
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
