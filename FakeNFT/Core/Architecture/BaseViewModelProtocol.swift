//
//  BaseViewModelProtocol.swift
//  FakeNFT
//
//  Created by Maksim Zakharov on 10.06.2025.
//
import SwiftUI

@MainActor
protocol BaseViewModelProtocol: ObservableObject {
    associatedtype DataType: Equatable
    var loadingState: LoadingState<DataType> { get set }
    var servicesAssembly: ServicesAssembly { get }
    
    func loadData() async
    func refresh() async
    func handleError(_ error: Error)
}
