//
//  MockMaintenanceEntryRepository.swift
//  car-journal
//

import Foundation

final class MockMaintenanceEntryRepository: MaintenanceEntryRepositoryProtocol {
    func list(carID: String, name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceEntryResponse> {
        PaginatedResponse(data: MaintenanceEntryResponse.mockEntries, meta: PaginationMeta(affectedRecords: 2, lastPage: 1, count: 2, hasNext: false))
    }
    func findByID(entryID: String) async throws -> MaintenanceEntryResponse {
        MaintenanceEntryResponse.mockEntries[0]
    }
    func create(carID: String, payload: MaintenanceEntryCreateRequest) async throws -> MutationResponse { MutationResponse(success: true) }
    func update(entryID: String, payload: MaintenanceEntryUpdateRequest) async throws -> MutationResponse { MutationResponse(success: true) }
    func delete(entryID: String) async throws -> MutationResponse { MutationResponse(success: true) }
}
