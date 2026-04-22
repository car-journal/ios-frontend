//
//  MaintenanceCategoryRepositoryImpl.swift
//  car-journal
//

final class MaintenanceCategoryRepositoryImpl: MaintenanceCategoryRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager

    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }

    func list(name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceCategoryResponse> {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceCategoryEndpoint.list(name: name, sorts: sorts, page: page, limit: limit, token: token)
        return try await apiClient.send(endpoint)
    }

    func findByID(categoryID: String) async throws -> MaintenanceCategoryResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceCategoryEndpoint.findByID(categoryID: categoryID, token: token)
        return try await apiClient.send(endpoint)
    }

    func create(payload: MaintenanceCategoryCreateRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceCategoryEndpoint.create(payload: payload, token: token)
        return try await apiClient.send(endpoint)
    }

    func update(categoryID: String, payload: MaintenanceCategoryUpdateRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceCategoryEndpoint.update(categoryID: categoryID, payload: payload, token: token)
        return try await apiClient.send(endpoint)
    }

    func delete(categoryID: String) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceCategoryEndpoint.delete(categoryID: categoryID, token: token)
        return try await apiClient.send(endpoint)
    }
}
