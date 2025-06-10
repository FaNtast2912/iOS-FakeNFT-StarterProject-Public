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
    
    @State private var showDeleteConfirmation = false
    @State private var nftToDelete: Nft?
    @State private var showSortOptions = false
    
    init(viewModel: CartViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            sortButton
            
            BaseContentView(
                loadingState: viewModel.loadingState,
                onRetry: { Task { await viewModel.loadData() } }
            ) { nfts in
                if nfts.isEmpty {
                    emptyCartView
                } else {
                    nftListView(nfts: nfts)
                }
            }
            
            paymentSummaryView
        }
        .progressHUD(isLoading: viewModel.loadingState.isLoading || viewModel.isDeleting)
        .overlay(deleteConfirmationOverlay)
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
        .alert("Ошибка", isPresented: .constant(viewModel.loadingState.error != nil)) {
            Button("Повторить") {
                Task { await viewModel.loadData() }
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text(viewModel.loadingState.error?.localizedDescription ?? "Произошла ошибка")
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
            .disabled(viewModel.loadingState.isLoading || viewModel.isDeleting)
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
                ForEach(viewModel.getSortedNFTs(), id: \.id) { nft in
                    NFTItemView(
                        nft: nft,
                        onDeleteTap: {
                            nftToDelete = nft
                            showDeleteConfirmation = true
                        }
                    )
                    .disabled(viewModel.isDeleting)
                    .opacity(viewModel.isDeleting ? 0.6 : 1.0)
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
                .disabled(viewModel.nfts.isEmpty || viewModel.loadingState.isLoading || viewModel.isDeleting)
                .opacity((viewModel.nfts.isEmpty || viewModel.loadingState.isLoading || viewModel.isDeleting) ? 0.6 : 1.0)
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
