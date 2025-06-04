import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    @State private var isShowingSortOptions = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing) {
                Button(action: {
                    isShowingSortOptions = true
                }) {
                    Image("yp.sort")
                }
                .frame(width: 42, height: 42)
                .padding(.bottom, 12)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(viewModel.sortedUsers.enumerated()), id: \.element.id) { index, user in
                            StatisticsCell(user: user, rank: index + 1)
                                .onTapGesture {
                                    navigationModel.navigate(to: .userCard(user: user))
                                }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            
            if isShowingSortOptions {
                Color.ypGreyUniversal.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: isShowingSortOptions)
            }
        }
        .confirmationDialog("Сортировка", isPresented: $isShowingSortOptions, titleVisibility: .visible) {
            Button("По имени") {
                viewModel.updateSortOption(.name)
            }
            Button("По рейтингу") {
                viewModel.updateSortOption(.rating)
            }
            Button("Закрыть", role: .cancel) {}
        }
    }
}

#Preview {
    StatisticsView()
}
