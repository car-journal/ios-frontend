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
        guard let token = authManager.getAccessToken() else {
            print("No access token, user is not logged in")
            throw CarRepositoryError.noAccessToken
        }

        let endpoint = CarEndpoint.list(page: page, token: token)
        
        return try await apiClient.send(endpoint)
    }
}
