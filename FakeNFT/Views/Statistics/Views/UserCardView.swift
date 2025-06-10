//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct UserCardView: View {
    let userId: String
    @StateObject private var viewModel: UserCardViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    init(userId: String, viewModel: UserCardViewModel) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseContentView(
            loadingState: viewModel.loadingState,
            onRetry: { Task { await viewModel.loadUser(by: userId) } }
        ) { user in
            // User card content implementation
            VStack {
                Text(user.name)
                    .font(.title)
                Text("Rating: \(user.rating)")
                Text("NFTs: \(user.nfts.count)")
                
                Button("View Collection") {
                    navigationModel.navigate(to: .userCollection(user: user))
                }
            }
            .padding()
        }
        .task {
            if case .idle = viewModel.loadingState {
                await viewModel.loadUser(by: userId)
            }
        }
    }
}

// Макс, не забудь!
//#Preview {
//    UserCardView(
//        userId: "1",
//        userService: MockUserByIdService()
//    )
//}
