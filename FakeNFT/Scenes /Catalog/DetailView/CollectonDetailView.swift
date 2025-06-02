//
//  CollectonDetailView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

/// Экран деталей коллекции NFT
struct CollectionDetailView: View {
    let collection: Collection
    @StateObject private var viewModel: CollectionDetailViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    init(collection: Collection) {
        self.collection = collection
        self._viewModel = StateObject(wrappedValue: CollectionDetailViewModel(collection: collection))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Обложка коллекции
                coverImage
            
                // Информация о коллекции
                collectionInfo
                
                // Список NFT
                nftContent
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadNFTs()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    // MARK: - BackButton
    
    private var backButton: some View {
        Button {
            navigationModel.navigateBack()
        } label: {
            Image("yp.chevron.backward")
                .foregroundColor(.ypBlack)
        }
    }
    
    // MARK: - Cover Image
    
    private var coverImage: some View {
        AsyncImage(url: collection.cover) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.ypLightGrey)
                .overlay {
                    ProgressView()
                        .tint(.ypBlueUniversal)
                }
        }
        .frame(height: 310)
        .clipped()
        .cornerRadius(12, corners: .bottomLeft)
        .cornerRadius(12, corners: .bottomRight)
    }
    
    // MARK: - Collection Info
    
    private var collectionInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Название коллекции
            Text(collection.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.ypBlackUniversal)
            
            // Автор коллекции
            HStack(spacing: 4.0) {
                Text("Автор Коллекции:")
                    .font(.system(size: 13, weight: .regular))
                Button {
                    navigationModel.IOScource()
                } label: {
                    Text(collection.author)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.ypBlueUniversal)
                }
            }

            // Описание
            Text(collection.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.ypBlackUniversal)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    // MARK: - NFT Content
    
    private var nftContent: some View {
        VStack {
            switch viewModel.loadingState {
            case .idle, .loading:
                loadingView
                    .padding(.top, 32)
                
            case .loaded(let nfts):
                CollectionsListView(nfts: nfts)
                    .padding(.top, 24)
                
            case .error(let message):
                errorView(message: message)
                    .padding(.top, 32)
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.ypBlueUniversal)
            
            Text("Загрузка NFT...")
                .font(.system(size: 15))
                .foregroundColor(.ypGreyUniversal)
                .padding(.top, 16)
        }
        .frame(height: 120)
    }
    
    // MARK: - Error View
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundColor(.ypRedUniversal)
            
            Text("Ошибка загрузки NFT")
                .font(.headline)
                .foregroundColor(.ypBlackUniversal)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.ypGreyUniversal)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Попробовать снова") {
                Task {
                    await viewModel.loadNFTs()
                }
            }
            .foregroundColor(.ypBlueUniversal)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.ypBlueUniversal.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(height: 200)
    }
}

// MARK: - Preview
#Preview {
    let sampleCollection = Collection(
        id: "sample-id",
        name: "Peach",
        cover: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!,
        nfts: ["28829968-8639-4e08-8853-2f30fcf09783", "77c9aa30-f07a-4bed-886b-dd41051fade2", "ca34d35a-4507-47d9-9312-5ea7053994c0"],
        description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательные нежность живая игривость сказочных зверей.",
        author: "John Doe",
        createdAt: "2023-11-21T15:21:36.683Z[GMT]"
    )
    
    NavigationView {
        CollectionDetailView(collection: sampleCollection)
            .environmentObject(NavigationModel())
    }
}
