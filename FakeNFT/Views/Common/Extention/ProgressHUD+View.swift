//
//  ProgressHUD+View.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

import SwiftUI

extension View {
    func progressHUD(isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ProgressHUD(isLoading: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
        )
    }
}
