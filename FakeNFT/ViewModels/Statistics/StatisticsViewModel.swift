//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

@MainActor
final class StatisticsViewModel: BaseViewModel<[User]> {
    @Published var sortOption: UnifiedSortOption = .userNftCount {
        didSet {
            UserDefaults.standard.set(sortOption.description, forKey: "userSortOption")
            updateSortedUsers()
        }
    }
    @Published var sortedUsers: [User] = []
    
    private var userService: UserServiceProtocol {
        servicesAssembly.userService
    }
    
    override init(servicesAssembly: ServicesAssembly) {
        super.init(servicesAssembly: servicesAssembly)
        
        // Load saved sort option
        if let savedOption = UserDefaults.standard.string(forKey: "userSortOption") {
            sortOption = UnifiedSortOption.from(string: savedOption) ?? .userNftCount
        }
    }
    
    override func loadData() async {
        setLoading()
        
        do {
            let users = try await userService.fetchAllUsers()
            setLoaded(users)
            updateSortedUsers()
        } catch {
            handleError(error)
        }
    }
    
    func updateSortOption(_ option: UnifiedSortOption) {
        sortOption = option
    }
    
    private func updateSortedUsers() {
        guard let users = loadingState.data else { return }
        sortedUsers = UnifiedSortingManager.shared.sort(items: users, by: sortOption) as? [User] ?? users
    }
}
