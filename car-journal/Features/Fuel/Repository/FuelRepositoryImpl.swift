//
//  FuelRepositoryImpl.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

final class FuelRepositoryImpl: FuelRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager
    
    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
    
    func list(name: String, page: Int, limit: Int) async throws -> PaginatedResponse<FuelListResponse> {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = FuelEndpoint.list(name: name, page: page, limit: limit, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
}
