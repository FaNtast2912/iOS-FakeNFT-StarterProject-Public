//
//  MainView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var navigationModel = NavigationModel()
    private var servicesAssembly: ServicesAssembly
    
    // Создаем CartViewModel через ServicesAssembly
    private var cartViewModel: CartViewModel {
        CartViewModel(cartManager: servicesAssembly.cartManager)
    }
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        // Настройка фона
        tabBarAppearance.backgroundColor = UIColor(.ypWhite)
        
        // Настройка обычного состояния (не выбран)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlack)
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.ypBlack)
        
        // Настройка выбранного состояния
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlueUniversal)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.ypBlueUniversal)
        
        // Настройка компактного режима (для маленьких экранов)
        tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlack)
        ]
        tabBarAppearance.compactInlineLayoutAppearance.normal.iconColor = UIColor(Color.ypBlack)
        
        tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlueUniversal)
        ]
        tabBarAppearance.compactInlineLayoutAppearance.selected.iconColor = UIColor(Color.ypBlueUniversal)
        
        // Применение настроек
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Дополнительные настройки
        UITabBar.appearance().tintColor = UIColor(Color.ypBlueUniversal)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.ypBlack)
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
                    .environmentObject(cartViewModel)
                    .tabItem {
                        Text("Корзина")
                        Image("yp.cartIcon")
                            .renderingMode(.template)
                    }
                    .tag(2)
                
                StatisticsView()
                    .environmentObject(StatisticsViewModel(userService: servicesAssembly.userService))
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
        .environmentObject(servicesAssembly.cartManager)
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    return AppTabView(servicesAssembly: services)
}
