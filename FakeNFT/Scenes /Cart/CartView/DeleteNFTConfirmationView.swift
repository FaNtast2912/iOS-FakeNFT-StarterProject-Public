//
//  DeleteNFTConfirmationView.swift
//  FakeNFT
//
//  Created by Kaider on 31.05.2025.
//

import SwiftUI

struct DeleteNFTConfirmationView: View {
    let nftImage: Image
    let onDelete: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.thinMaterial)
                .ignoresSafeArea()
            
            VStack {
                Image("yp.nftdelete")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 108, height: 108)
                
                Text("Вы уверены, что хотите\nудалить объект из корзины?")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.ypBlackUniversal)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                
                HStack {
                    Button(action: {
                        onDelete()
                    }, label: {
                        Text("Удалить")
                            .frame(width: 127, height: 44)
                            .font(.system(size: 17, weight: .regular))
                            .background(Color.ypBlackUniversal)
                            .foregroundColor(.red)
                            .cornerRadius(16)
                    })
                    
                    Button(action: {
                        onCancel()
                    }, label: {
                        Text("Вернуться")
                            .frame(width: 127, height: 44)
                            .font(.system(size: 17, weight: .regular))
                            .background(Color.ypBlackUniversal)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    })
                }
            }
        }
    }
}

#Preview {
    DeleteNFTConfirmationView(
        nftImage: Image("mockImageNFT"),
        onDelete: {},
        onCancel: {}
    )
}
