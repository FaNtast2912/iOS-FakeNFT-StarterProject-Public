
//
//  ProgressHUD.swift
//  FakeNFT
//
//  Created by Kaider on 24.05.2025.
//

import SwiftUI

struct ProgressHUD: View {
    let isLoading: Bool

    init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    var body: some View {
        if isLoading {
            ZStack {
                Color.ypLightGrey.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .frame(width: 82, height: 82)
                    .background(Color.ypLightGrey)
                    .cornerRadius(16)
            }
            .transition(.opacity)
        }
    }
}

// MARK: - Extention для использования в проекте
// .progressHUD(isLoading:)

extension View {
    func progressHUD(isLoading: Bool) -> some View {
        self.overlay(
            ProgressHUD(isLoading: isLoading)
        )
    }
}
struct ProgressHUD_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Text("Фоновый контент")
        }
        .progressHUD(isLoading: true)
    }
}
