//
//  FuelEntryRepositoryImpl.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

final class FuelEntryRepositoryImpl: FuelEntryRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager
    
    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
    
    func create(payload: FuelEntryCreateRequest) async throws -> MutationResponse {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = FuelEntryEndpoint.create(payload: payload, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
}
