import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(navigation)
        }
    }
}

