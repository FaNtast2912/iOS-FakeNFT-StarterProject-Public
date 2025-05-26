//
//  MainView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var navigationModel = NavigationModel()
    
    init() {
        // по идее надо перенести куда-то во вью модель или оставить здесь
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        
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
                ProfileView()
                    .tabItem {
                        Text("Профиль")
                        Image("yp.profileIcon")
                            .renderingMode(.template)
                    }
                    .tag(0)
                
                CatalogView()
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
                
            }
        }
        .environmentObject(navigationModel)
    }
}

#Preview {
    AppTabView()
        .environmentObject(NavigationModel())
}
