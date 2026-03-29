//
//  CarRepositoryImpl.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

final class CarRepositoryImpl: CarRepository {
    private let apiClient: APIClient
    private let authManager: AuthManager
    
    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }
    
    func list(page: Int) async throws -> PaginatedResponse<CarListResponse> {
        let token = try requireAccessToken()
        let endpoint = CarEndpoint.list(page: page, token: token)
        return try await apiClient.send(endpoint)
    }
    
    func findByID(carID: String) async throws -> CarDetailResponse {
        do {
            let token = try requireAccessToken()
            let endpoint = CarEndpoint.findByID(carID: carID, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            print("findByID error:", error)
            throw error
        }
    }
    
    private func requireAccessToken() throws -> String {
        guard let token = authManager.getAccessToken() else {
            print("No access token, user is not logged in")
            throw CarRepositoryError.noAccessToken
        }
        
        return token
    }
}
