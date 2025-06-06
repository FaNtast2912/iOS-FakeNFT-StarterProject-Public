import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    var body: some Scene {
        WindowGroup {
            let navigation = NavigationModel(services: servicesAssembly)
            AppTabView(servicesAssembly: servicesAssembly)
                .environmentObject(navigation)
        }
    }
}



