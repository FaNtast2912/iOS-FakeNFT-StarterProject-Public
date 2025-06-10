//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Анна Браун on 29.05.2025.
//
import Foundation

@MainActor
final class UserCardViewModel: BaseViewModel<User> {
    private var userByIdService: UserByIdServiceProtocol {
        servicesAssembly.userByIdService
    }
    
    override func loadData() async {
        // Should not be called without user ID
        fatalError("Use loadUser(by:) instead")
    }
    
    func loadUser(by id: String) async {
        setLoading()
        
        do {
            let user = try await userByIdService.fetchUser(by: id)
            setLoaded(user)
        } catch {
            handleError(error)
        }
    }
    
    func loadMockUser(user: User) {
        setLoaded(user)
    }
}
