import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    private var servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
    
    var body: some Scene {
        WindowGroup {
            AppTabView(servicesAssembly: servicesAssembly)
                .environmentObject(navigation)
        }
    }
}

