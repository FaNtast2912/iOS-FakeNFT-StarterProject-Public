import SwiftUI

/// Основной экран каталога коллекций NFT
struct CatalogListView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var showingSortOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ypWhite
                    .ignoresSafeArea()
                
                switch viewModel.loadingState {
                case .idle, .loading:
                    loadingView
                    
                case .loaded(let collections):
                    collectionsList(collections: collections)
                    
                case .error(let message):
                    errorView(message: message)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    sortButton
                }
            }
            .confirmationDialog("Сортировка", isPresented: $showingSortOptions, titleVisibility: .visible) {
                Button("По названию") {
                    viewModel.sortCollections(by: .name(ascending: true))
                }
                Button("По количеству") {
                    viewModel.sortCollections(by: .nftCount(ascending: false))
                }
                Button("Закрыть", role: .cancel) {}
            }
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadCollections()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressHUD(isLoading: true)
            Spacer()
        }
    }
    
    // MARK: - Collections List
    
    private func collectionsList(collections: [Collection]) -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(collections) { collection in
                    CatalogRowView(collection: collection)
                        .onTapGesture {
                            // Устанавливаем выбранную коллекцию перед навигацией
                            navigationModel.selectedCollection = collection
                            navigationModel.navigate(to: .collectionDetailView)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    // MARK: - Error View
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.ypRedUniversal)
            
            Text("Ошибка загрузки")
                .font(.headline)
                .foregroundColor(.ypBlackUniversal)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.ypGreyUniversal)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Попробовать снова") {
                Task {
                    await viewModel.loadCollections()
                }
            }
            .foregroundColor(.ypBlueUniversal)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.ypBlueUniversal.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Sort Button
    
    private var sortButton: some View {
        Button {
            showingSortOptions = true
        } label: {
            Image("yp.sort")
                .foregroundColor(.ypBlack)
        }
    }
}

// MARK: - Preview

#Preview {
    CatalogListView()
        .environmentObject(NavigationModel())
}
