//
//  MockMaintenanceCategoryRepository.swift
//  car-journal
//

import Foundation

final class MockMaintenanceCategoryRepository: MaintenanceCategoryRepositoryProtocol {
    func list(name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceCategoryResponse> {
        PaginatedResponse(data: MaintenanceCategoryResponse.mockCategories, meta: PaginationMeta(affectedRecords: 6, lastPage: 1, count: 6, hasNext: false))
    }
    func findByID(categoryID: String) async throws -> MaintenanceCategoryResponse {
        MaintenanceCategoryResponse.mockCategories[0]
    }
    func create(payload: MaintenanceCategoryCreateRequest) async throws -> MutationResponse { MutationResponse(success: true) }
    func update(categoryID: String, payload: MaintenanceCategoryUpdateRequest) async throws -> MutationResponse { MutationResponse(success: true) }
    func delete(categoryID: String) async throws -> MutationResponse { MutationResponse(success: true) }
}
