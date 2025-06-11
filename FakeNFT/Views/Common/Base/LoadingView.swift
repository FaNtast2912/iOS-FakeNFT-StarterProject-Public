//
//  Untitled.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(message: String = "") {
        self.message = message
    }
    
    var body: some View {
        VStack {
            ProgressHUD(isLoading: true)
            
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.ypGreyUniversal)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
    }
}
