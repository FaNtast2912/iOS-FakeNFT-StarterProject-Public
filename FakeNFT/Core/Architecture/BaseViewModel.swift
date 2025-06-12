//
//  BaseViewModel.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import SwiftUI

@MainActor
class BaseViewModel<T: Equatable>: BaseViewModelProtocol, ObservableObject {
    typealias DataType = T
    
    @Published var loadingState: LoadingState<T> = .idle
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func loadData() async {
        fatalError("loadData() must be implemented by subclasses")
    }
    
    func refresh() async {
        await loadData()
    }
    
    func handleError(_ error: Error) {
        print("[\(type(of: self))] Error: \(error)")
        loadingState = .error(error)
    }
    
    func setLoading() {
        loadingState = .loading
    }
    
    func setLoaded(_ data: T) {
        loadingState = .loaded(data)
    }
    
    func setIdle() {
        loadingState = .idle
    }
}
