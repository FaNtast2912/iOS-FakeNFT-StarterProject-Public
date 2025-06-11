import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var isShowingSortOptions = false
    
    init(viewModel: StatisticsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BaseContentView(
                loadingState: viewModel.loadingState,
                onRetry: { Task { await viewModel.loadData() } }
            ) { _ in
                statisticsContent
            }
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadData()
            }
        }
    }
    
    private var statisticsContent: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                isShowingSortOptions = true
            }) {
                Image("yp.sort")
            }
            .frame(width: 42, height: 42)
            .padding(.bottom, 12)
            
            ScrollView {
                LazyVStack(spacing: AppConstants.UI.defaultSpacing) {
                    ForEach(Array(viewModel.sortedUsers.enumerated()), id: \.element.id) { index, user in
                        StatisticsCell(user: user, rank: index + 1)
                            .onTapGesture {
                                navigationModel.navigate(to: .userCard(user: user))
                            }
                    }
                }
            }
        }
        .padding(.horizontal, AppConstants.UI.defaultPadding)
        .confirmationDialog("Сортировка", isPresented: $isShowingSortOptions, titleVisibility: .visible) {
            Button("По имени") {
                viewModel.updateSortOption(.userName)
            }
            Button("По рейтингу") {
                viewModel.updateSortOption(.userRating)
            }
            Button("Закрыть", role: .cancel) {}
        }
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    return StatisticsViewFactory(servicesAssembly: mockServices)
        .environmentObject(NavigationModel())
}
