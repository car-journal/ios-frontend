//
//  AppContainer.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

@MainActor
final class AppContainer {
    private let baseURL = URL(string: "http://192.168.18.175:8080")!
    let authManager: AuthManager
    
    init() {
        let tokenStore = TokenStore()
        self.authManager = AuthManager(tokenStore: tokenStore)
    }
    
    lazy var apiClient: APIClient = {
        APIClient(baseURL: baseURL)
    }()
    
    lazy var authRepository: AuthRepository = {
        AuthRepositoryImpl(apiClient: apiClient)
    }()
    
    lazy var carRepository: CarRepository = {
        CarRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()
}
