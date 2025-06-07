//
//  CartView.swift
//  FakeNFT
//
//  Created by Kaider on 27.05.2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var navigation: NavigationModel
    @EnvironmentObject var viewModel: CartViewModel
    
    @State private var showDeleteConfirmation = false
    @State private var nftToDelete: Nft?
    @State private var showSortOptions = false
    
    private enum Constants {
        static let sortButtonImageSize: CGFloat = 21
        static let sortButtonImageHeight: CGFloat = 12.6
        static let sortButtonTrailingPadding: CGFloat = 19.5
        static let emptyCartFontSize: CGFloat = 17
        static let nftListTopPadding: CGFloat = 36
        static let nftListHorizontalPadding: CGFloat = 16
        static let nftListSpacing: CGFloat = 16
        static let paymentSummaryHeight: CGFloat = 76
        static let paymentSummaryCornerRadius: CGFloat = 12
        static let paymentSummaryHorizontalPadding: CGFloat = 16
        static let nftCountFontSize: CGFloat = 15
        static let priceFontSize: CGFloat = 17
        static let payButtonWidth: CGFloat = 240
        static let payButtonHeight: CGFloat = 44
        static let payButtonCornerRadius: CGFloat = 16
    }
    
    var body: some View {
        VStack(spacing: 0) {
            sortButton
            
            if viewModel.nfts.isEmpty && !viewModel.isLoading {
                emptyCartView
            } else {
                nftListView
            }
            
            paymentSummaryView
        }
        .progressHUD(isLoading: viewModel.isLoading)
        .overlay(deleteConfirmationOverlay)
        .onAppear {
            viewModel.loadCartItems()
        }
        .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
            Button("Повторить") {
                viewModel.loadCartItems()
            }
            Button("Отмена", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка")
        }
    }
    
    // MARK: - Private Subviews
    
    private var sortButton: some View {
        HStack {
            Spacer()
            Button(
                action: { showSortOptions.toggle() },
                label: {
                    Image("yp.sort")
                        .resizable()
                        .frame(
                            width: Constants.sortButtonImageSize,
                            height: Constants.sortButtonImageHeight
                        )
                        .foregroundColor(.black)
                        .padding(.trailing, Constants.sortButtonTrailingPadding)
                }
            )
            .confirmationDialog(
                "Сортировка",
                isPresented: $showSortOptions
            ) {
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
                .font(.system(size: Constants.emptyCartFontSize, weight: .bold))
                .foregroundColor(.ypBlackUniversal)
            Spacer()
        }
    }
    
    private var nftListView: some View {
        ScrollView {
            LazyVStack(spacing: Constants.nftListSpacing) {
                ForEach(viewModel.getSortedNFTs(), id: \.id) { nft in
                    NFTItemView(
                        nft: nft,
                        onDeleteTap: {
                            nftToDelete = nft
                            showDeleteConfirmation = true
                        }
                    )
                }
            }
            .padding(.top, Constants.nftListTopPadding)
            .padding(.horizontal, Constants.nftListHorizontalPadding)
        }
    }
    
    private var paymentSummaryView: some View {
        ZStack {
            Rectangle()
                .fill(Color(UIColor.systemGray6))
                .frame(height: Constants.paymentSummaryHeight)
                .cornerRadius(Constants.paymentSummaryCornerRadius)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(viewModel.nfts.count) NFT")
                        .font(.system(size: Constants.nftCountFontSize, weight: .regular))
                        .padding(.bottom, 2)
                    
                    Text(viewModel.formattedTotalPrice)
                        .font(.system(size: Constants.priceFontSize, weight: .bold))
                        .foregroundColor(.ypGreenUniversal)
                }
                
                Spacer()
                
                Button(
                    action: { navigation.navigate(to: .paymentMethodView) },
                    label: {
                        Text("К оплате")
                            .frame(
                                width: Constants.payButtonWidth,
                                height: Constants.payButtonHeight
                            )
                            .font(.system(size: Constants.priceFontSize, weight: .bold))
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.payButtonCornerRadius)
                    }
                )
                .disabled(viewModel.nfts.isEmpty || viewModel.isLoading)
                .opacity((viewModel.nfts.isEmpty || viewModel.isLoading) ? 0.6 : 1.0)
            }
            .padding(.horizontal, Constants.paymentSummaryHorizontalPadding)
        }
    }
    
    private var deleteConfirmationOverlay: some View {
        Group {
            if showDeleteConfirmation, let nft = nftToDelete {
                DeleteNFTConfirmationView(
                    nftImage: Image("mockImageNFT"),
                    onDelete: {
                        viewModel.deleteNFT(nft.id)
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

#Preview("With Data") {
    CartView()
        .environmentObject(NavigationModel())
        .environmentObject({
            let networkClient = DefaultNetworkClient()
            let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
            let nftStorage = NftStorageImpl()
            let servicesAssembly = ServicesAssembly(
                networkClient: networkClient,
                nftStorage: nftStorage
            )
            let cartManager = CartManager()
            
            return CartViewModel(
                cartManager: cartManager,
                cartNetworkService: cartNetworkService,
                nftService: servicesAssembly.nftService
            )
        }())
}

#Preview("Loading State") {
    CartView()
        .environmentObject(NavigationModel())
        .environmentObject({
            let networkClient = DefaultNetworkClient()
            let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
            let nftStorage = NftStorageImpl()
            let servicesAssembly = ServicesAssembly(
                networkClient: networkClient,
                nftStorage: nftStorage
            )
            let cartManager = CartManager()
            
            let viewModel = CartViewModel(
                cartManager: cartManager,
                cartNetworkService: cartNetworkService,
                nftService: servicesAssembly.nftService
            )
            viewModel.isLoading = true 
            return viewModel
        }())
}

#Preview("Empty Cart") {
    CartView()
        .environmentObject(NavigationModel())
        .environmentObject({
            let networkClient = DefaultNetworkClient()
            let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
            let nftStorage = NftStorageImpl()
            let servicesAssembly = ServicesAssembly(
                networkClient: networkClient,
                nftStorage: nftStorage
            )
            let cartManager = CartManager()
            
            return CartViewModel(
                cartManager: cartManager,
                cartNetworkService: cartNetworkService,
                nftService: servicesAssembly.nftService
            )
        }())
}
