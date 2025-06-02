//
//  PaymentDoneView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct PaymentDoneView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    
    var body: some View {
        VStack {
            Text("Экран будет реализован во второй части эпика")
        }
        .navigationBarStyle {
            navigationModel.navigateBack()
        }
        .navigationTitle("Оплата")
    }
}

#Preview {
    PaymentDoneView()
}
