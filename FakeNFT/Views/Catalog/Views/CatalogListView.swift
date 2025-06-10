import SwiftUI

/// Основной экран каталога коллекций NFT
struct CatalogListView: View {
    @StateObject private var viewModel: CatalogViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var showingSortOptions = false
    
    init(viewModel: CatalogViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ypWhite.ignoresSafeArea()
                
                BaseContentView(
                    loadingState: viewModel.loadingState,
                    onRetry: { Task { await viewModel.loadData() } }
                ) { collections in
                    collectionsList(collections: collections)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    sortButton
                }
            }
            .confirmationDialog("Сортировка", isPresented: $showingSortOptions, titleVisibility: .visible) {
                Button("По названию") {
                    viewModel.sortCollections(by: .collectionName(ascending: true))
                }
                Button("По количеству") {
                    viewModel.sortCollections(by: .collectionNftCount(ascending: false))
                }
                Button("Закрыть", role: .cancel) {}
            }
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private func collectionsList(collections: [NFTCollections]) -> some View {
        ScrollView {
            LazyVStack(spacing: AppConstants.UI.defaultSpacing) {
                ForEach(viewModel.sortedCollections) { collection in
                    CatalogRowView(collection: collection)
                        .onTapGesture {
                            navigationModel.selectedCollection = collection
                            navigationModel.navigate(to: .collectionDetailView)
                        }
                }
            }
            .padding([.horizontal, .top], AppConstants.UI.defaultPadding)
        }
    }
    
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
    let mockServices = MockServicesAssembly()
    return CatalogListViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
