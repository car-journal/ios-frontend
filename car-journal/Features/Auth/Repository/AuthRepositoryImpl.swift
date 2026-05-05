//
//  AuthRepositoryImpl.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = AuthEndpoint.login(email: email, password: password)
        return try await apiClient.send(endpoint)
    }

    func register(payload: RegisterRequest) async throws -> MutationResponse {
        let endpoint = AuthEndpoint.register(payload: payload)
        return try await apiClient.send(endpoint)
    }
}
