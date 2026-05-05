//
//  MaintenanceEntryRepositoryImpl.swift
//  car-journal
//

final class MaintenanceEntryRepositoryImpl: MaintenanceEntryRepositoryProtocol {
    private let apiClient: APIClient
    private let authManager: AuthManager

    init(apiClient: APIClient, authManager: AuthManager) {
        self.apiClient = apiClient
        self.authManager = authManager
    }

    func list(carID: String, name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceEntryResponse> {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceEntryEndpoint.list(carID: carID, name: name, sorts: sorts, page: page, limit: limit, token: token)
        return try await apiClient.send(endpoint)
    }

    func findByID(entryID: String) async throws -> MaintenanceEntryResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceEntryEndpoint.findByID(entryID: entryID, token: token)
        return try await apiClient.send(endpoint)
    }

    func create(carID: String, payload: MaintenanceEntryCreateRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceEntryEndpoint.create(carID: carID, payload: payload, token: token)
        return try await apiClient.send(endpoint)
    }

    func update(entryID: String, payload: MaintenanceEntryUpdateRequest) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceEntryEndpoint.update(entryID: entryID, payload: payload, token: token)
        return try await apiClient.send(endpoint)
    }

    func delete(entryID: String) async throws -> MutationResponse {
        let token = try authManager.requireAccessToken()
        let endpoint = MaintenanceEntryEndpoint.delete(entryID: entryID, token: token)
        return try await apiClient.send(endpoint)
    }
}
