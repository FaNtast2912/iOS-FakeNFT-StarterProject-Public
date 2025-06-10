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
                        loadingMessage: "Загрузка NFT...",
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
            .environmentObject(servicesAssembly.likesManager)
        }
        .task {
            if case .idle = viewModel.loadingState {
                async let loadNFTs: Void = viewModel.loadData()
                async let loadLikes: Void = servicesAssembly.likesManager.loadLikes()
                
                await loadNFTs
                await loadLikes
            }
        }
        .refreshable {
            async let refreshNFTs: Void = viewModel.refresh()
            async let refreshLikes: Void = servicesAssembly.likesManager.loadLikes()
            
            await refreshNFTs
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
}


//МАКС не забудь!
// MARK: - Preview
//#Preview {
//    let sampleCollection = NFTCollections(
//        id: "sample-id",
//        name: "Peach",
//        cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!,
//        nfts: ["28829968-8639-4e08-8853-2f30fcf09783", "77c9aa30-f07a-4bed-886b-dd41051fade2", "ca34d35a-4507-47d9-9312-5ea7053994c0"],
//        description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательные нежность живая игривость сказочных зверей.",
//        author: "John Doe",
//        createdAt: "2023-11-21T15:21:36.683Z[GMT]"
//    )
//    
//    // Создаем мок-сервисы для превью
//    let mockNetworkClient = DefaultNetworkClient()
//    let mockNftStorage = NftStorageImpl()
//    let mockServicesAssembly = ServicesAssembly(networkClient: mockNetworkClient, nftStorage: mockNftStorage)
//    
//    NavigationView {
//        CollectionDetailView(collection: sampleCollection)
//            .environmentObject(NavigationModel())
//            .environmentObject(mockServicesAssembly)
//    }
//}
