import SwiftUI

@main
struct FakeNFTApp: App {
    @StateObject private var navigation = NavigationModel()
    @StateObject private var mockData = MockData()

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(navigation)
                .environmentObject(mockData)
        }
    }
}
