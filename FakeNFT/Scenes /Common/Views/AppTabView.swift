//
//  MainView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var cartManager = CartManager()
    private var servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        
        // настраиваем иконки таб бара
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.ypBlack)]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.ypBlueUniversal)
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TabView(selection: $navigationModel.selectedTab) {
                ProfileView(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Профиль")
                        Image("yp.profileIcon")
                            .renderingMode(.template)
                    }
                    .tag(0)
                
                CatalogListView()
                    .tabItem {
                        Text("Каталог")
                        Image("yp.catalogIcon")
                            .renderingMode(.template)
                    }
                    .tag(1)
                
                CartView()
                    .tabItem {
                        Text("Корзина")
                        Image("yp.cartIcon")
                            .renderingMode(.template)
                    }
                    .tag(2)
                
                StatisticsView()
                    .tabItem {
                        Text("Статистика")
                        Image("yp.statisticsIcon")
                            .renderingMode(.template)
                    }
                    .tag(3)
            }
            // Общая обработка навигации для всех табов
            .navigationDestination(for: Screens.self) { screen in
                navigationModel.destination(for: screen, with: servicesAssembly)
            }
        }
        .environmentObject(navigationModel)
        .environmentObject(servicesAssembly)
        .environmentObject(servicesAssembly.likesManager)
        .environmentObject(cartManager)
    }
}

#Preview {
    AppTabView(servicesAssembly: ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        .environmentObject(NavigationModel())
}
