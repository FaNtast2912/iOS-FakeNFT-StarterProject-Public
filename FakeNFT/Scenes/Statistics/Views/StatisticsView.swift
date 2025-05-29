import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        ScrollView {
            
            LazyVStack(spacing: 8) {
                ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                    StatisticsCell(user: user, rank: index + 1)
                        .onTapGesture {
                            navigationModel.navigate(to: .userCard(user: user))
                        }
                }
            }
            .padding()
            
        }
    }
}

#Preview {
    StatisticsView()
}
