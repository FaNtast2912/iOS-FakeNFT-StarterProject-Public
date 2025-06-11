//
//  CollectonDetailView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 28.05.2025.
//

import SwiftUI

/// Экран деталей коллекции NFT
struct CollectionDetailView: View {
    @StateObject private var viewModel: CollectionDetailViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var servicesAssembly: ServicesAssembly
    
    init(viewModel: CollectionDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.ypWhite.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    coverImage
                    collectionInfo
                    
                    BaseContentView(
                        loadingState: viewModel.loadingState,
                        onRetry: { Task { await viewModel.loadData() } }
                    ) { nfts in
                        CollectionsListView(nfts: nfts)
                            .padding(.top, 24)
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
        }
        .environmentObject(servicesAssembly.getCartManagerWrapper())
        .environmentObject(servicesAssembly.getLikesManagerWrapper())
        .task {
            if case .idle = viewModel.loadingState {
                async let loadNFTs: Void = viewModel.loadData()
                async let loadCart: Void = loadCartData()
                async let loadLikes: Void = loadLikesData()
                
                await loadNFTs
                await loadCart
                await loadLikes
            }
        }
        .refreshable {
            async let refreshNFTs: Void = viewModel.refresh()
            async let refreshCart: Void = servicesAssembly.getCartManagerWrapper().refresh()
            async let refreshLikes: Void = servicesAssembly.getLikesManagerWrapper().refresh()
            
            await refreshNFTs
            await refreshCart
            await refreshLikes
        }
    }
    
    private var backButton: some View {
        Button {
            navigationModel.navigateBack()
        } label: {
            Image("yp.chevron.backward")
                .tint(.ypWhiteUniversal)
        }
    }
    
    private var coverImage: some View {
        AsyncImage(url: viewModel.currentCollection.cover) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.ypLightGrey)
                .overlay {
                    ProgressHUD(isLoading: true)
                }
        }
        .frame(height: 310)
        .clipped()
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
    
    private var collectionInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.currentCollection.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.ypBlack)
            
            HStack(spacing: 4.0) {
                Text("Автор Коллекции:")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.ypBlack)
                Button {
                    navigationModel.IOScource()
                } label: {
                    Text(viewModel.currentCollection.author)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.ypBlueUniversal)
                }
            }
            
            Text(viewModel.currentCollection.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.ypBlack)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .padding(.top, AppConstants.UI.defaultPadding)
    }
    
    // MARK: - Private Methods
    
    private func loadCartData() async {
        servicesAssembly.getCartManagerWrapper().loadCart()
    }
    
    private func loadLikesData() async {
        servicesAssembly.getLikesManagerWrapper().loadLikes()
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    let mockCollection = NFTCollections(
        id: "sample-id",
        name: "Peach Collection",
        cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!,
        nfts: ["1", "2", "3"],
        description: "Beautiful peach colored NFT collection with amazing artworks",
        author: "John Doe",
        createdAt: "2023-11-21T15:21:36.683Z[GMT]"
    )
    
    return NavigationView {
        CollectionDetailViewFactory(collection: mockCollection, servicesAssembly: mockServices)
            .environmentObject(NavigationModel())
            .environmentObject(mockServices)
    }
}
