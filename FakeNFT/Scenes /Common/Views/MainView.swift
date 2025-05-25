//
//  MainView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    
    init() {
        // по идее надо перенести куда-то во вью модель или оставить здесь
        let servicesAssembly = ServicesAssembly(
              networkClient: DefaultNetworkClient(),
              nftStorage: NftStorageImpl()
          )
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AppTabView()
}
