//
//  PaymentDoneView.swift
//  FakeNFT
//
//  Created by Kaider on 28.05.2025.
//

import SwiftUI

struct PaymentDoneView: View {
    @EnvironmentObject var navigation: NavigationModel
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image("yp.successfulPaymentImg")
                .resizable()
                .frame(width: 278, height: 278)
            
            Text("Успех! Оплата прошла,\n поздравляем с покупкой!")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Button(
                action: {
                    navigation.switchToTab(1)
                    navigation.navigateToRoot()
                },
                label: {
                    Text("Вернуться в каталог")
                        .frame( width: 343, height: 60)
                        .font(.system(size: 17, weight: .bold))
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            )
            .padding(.top, 152)
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PaymentDoneView()
        .environmentObject(NavigationModel())
}
