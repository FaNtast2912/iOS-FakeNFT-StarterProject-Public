//
//  AppTabView.swift
//  FakeNFT
//
//  Created by Olga Trofimova on 25.05.2025.
//

import SwiftUI

struct AppTabView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @ObservedObject private var servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        tabBarAppearance.backgroundColor = UIColor(.ypWhite)
        
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlack)
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.ypBlack)
        
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.ypBlueUniversal)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.ypBlueUniversal)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UIColor(Color.ypBlueUniversal)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.ypBlack)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TabView(selection: $navigationModel.selectedTab) {
                ProfileViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Профиль")
                        Image("yp.profileIcon")
                            .renderingMode(.template)
                    }
                    .tag(0)
                
                CatalogListViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Каталог")
                        Image("yp.catalogIcon")
                            .renderingMode(.template)
                    }
                    .tag(1)
                
                CartViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Корзина")
                        Image("yp.cartIcon")
                            .renderingMode(.template)
                    }
                    .tag(2)
                
                StatisticsViewFactory(servicesAssembly: servicesAssembly)
                    .tabItem {
                        Text("Статистика")
                        Image("yp.statisticsIcon")
                            .renderingMode(.template)
                    }
                    .tag(3)
            }
            .navigationDestination(for: Screens.self) { screen in
                navigationModel.destination(for: screen, with: servicesAssembly)
            }
            .environmentObject(servicesAssembly.getCartManagerWrapper())
            .environmentObject(servicesAssembly.getLikesManagerWrapper())
        }
        .task {
            // Загружаем начальные данные при старте приложения
            await loadInitialData()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadInitialData() async {
        // Загружаем данные параллельно
        async let loadCart: Void = servicesAssembly.getCartManagerWrapper().loadCart()
        async let loadLikes: Void = servicesAssembly.getLikesManagerWrapper().loadLikes()
        
        await loadCart
        await loadLikes
    }
}

#Preview {
    let mockServices = MockServicesAssembly()
    let navigationModel = NavigationModel()
    return AppTabView(
        servicesAssembly: mockServices
    )
    .environmentObject(navigationModel)
}
