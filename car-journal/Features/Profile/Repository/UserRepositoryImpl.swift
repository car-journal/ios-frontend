//
//  UserRepositoryImpl.swift
//  car-journal
//

final class UserRepositoryImpl: UserRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager

    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }

    func me() async throws -> UserProfileResponse {
        let token = try authManager.requireAccessToken()
        return try await apiClient.send(UserEndpoint.me(token: token))
    }

    func updateProfile(payload: UpdateUserProfileRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        return try await apiClient.send(UserEndpoint.updateProfile(payload: payload, token: token))
    }

    func updatePassword(payload: UpdatePasswordRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        return try await apiClient.send(UserEndpoint.updatePassword(payload: payload, token: token))
    }
}
