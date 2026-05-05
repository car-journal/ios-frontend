//
//  AppContainer.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

@MainActor
final class AppContainer {
    private let baseURL = AppConfig.baseURL
    let authManager: AuthManager

    init() {
        let tokenStore = TokenStore()
        self.authManager = AuthManager(tokenStore: tokenStore)
    }

    lazy var apiClient: APIClient = {
        APIClient(baseURL: baseURL)
    }()

    lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepositoryImpl(apiClient: apiClient)
    }()

    lazy var carRepository: CarRepositoryProtocol = {
        CarRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()

    lazy var fuelRepository: FuelRepositoryProtocol = {
        FuelRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()

    lazy var fuelEntryRepository: FuelEntryRepositoryProtocol = {
        FuelEntryRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()

    lazy var maintenanceEntryRepository: MaintenanceEntryRepositoryProtocol = {
        MaintenanceEntryRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()

    lazy var maintenanceCategoryRepository: MaintenanceCategoryRepositoryProtocol = {
        MaintenanceCategoryRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()

    lazy var userRepository: UserRepositoryProtocol = {
        UserRepositoryImpl(apiClient: apiClient, authManager: authManager)
    }()
}
