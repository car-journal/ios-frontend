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
    
    func listByCarID(carID: String, page: Int, limit: Int) async throws -> PaginatedResponse<FuelEntryResponse> {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = CarEndpoint.listOfFuelEntries(carID: carID, page: page, limit: limit, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
    
    func findByID(fuelEntryID: String) async throws -> FuelEntryResponse {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = FuelEntryEndpoint.findByID(fuelEntryID: fuelEntryID, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
    
    func update(fuelEntryID: String, payload: FuelEntryUpdateRequest) async throws -> MutationResponse {
        do {
            let token = try authManager.requireAccessToken()
            let endpoint = FuelEntryEndpoint.update(fuelEntryID: fuelEntryID, payload: payload, token: token)
            return try await apiClient.send(endpoint)
        } catch {
            throw error
        }
    }
}
