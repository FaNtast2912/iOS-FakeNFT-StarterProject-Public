//
//  LoadingState.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//

enum LoadingState<T>: Equatable where T: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(Error)
    
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lhsData), .loaded(let rhsData)):
            return lhsData == rhsData
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var error: Error? {
        if case .error(let error) = self { return error }
        return nil
    }
    
    var data: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
}
