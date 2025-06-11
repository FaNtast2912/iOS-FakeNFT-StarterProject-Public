//
//  BaseContentView.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

struct BaseContentView<Data: Equatable, Content: View>: View {
    let loadingState: LoadingState<Data>
    let onRetry: () -> Void
    @ViewBuilder let content: (Data) -> Content
    
    init(
        loadingState: LoadingState<Data>,
        onRetry: @escaping () -> Void,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.loadingState = loadingState
        self.onRetry = onRetry
        self.content = content
    }
    
    var body: some View {
        switch loadingState {
        case .idle, .loading:
            LoadingView()
            
        case .loaded(let data):
            content(data)
            
        case .error(let error):
            ErrorView(message: error.localizedDescription, onRetry: onRetry)
        }
    }
}
