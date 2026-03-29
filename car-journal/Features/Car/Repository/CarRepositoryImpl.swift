//
//  CarRepositoryImpl.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

final class CarRepositoryImpl: CarRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager
    
    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
    
    func list(page: Int) async throws -> PaginatedResponse<CarListResponse> {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = CarEndpoint.list(page: page, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
    
    func findByID(carID: String) async throws -> CarDetailResponse {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = CarEndpoint.findByID(carID: carID, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
}
