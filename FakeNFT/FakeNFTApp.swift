import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var mockData = MockData()
    @StateObject private var cartManager = CartManager()
    
    // Создаем сетевые сервисы через ServicesAssembly
    private let networkClient = DefaultNetworkClient()
    private lazy var nftStorage = NftStorageImpl()
    private lazy var servicesAssembly = ServicesAssembly(
        networkClient: networkClient,
        nftStorage: nftStorage
    )
    
    @StateObject private var cartViewModel: CartViewModel = {
        let networkClient = DefaultNetworkClient()
        let cartNetworkService = DefaultCartNetworkService(networkClient: networkClient)
        let nftStorage = NftStorageImpl()
        let servicesAssembly = ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
        let cartManager = CartManager()
        
        return CartViewModel(
            cartManager: cartManager,
            cartNetworkService: cartNetworkService,
            nftService: servicesAssembly.nftService
        )
    }()

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(navigation)
                .environmentObject(mockData)
                .environmentObject(cartManager)
                .environmentObject(cartViewModel)
        }
    }
}
