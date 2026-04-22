//
//  MaintenanceCategoryRepository.swift
//  car-journal
//

protocol MaintenanceCategoryRepositoryProtocol {
    func list(name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceCategoryResponse>
    func findByID(categoryID: String) async throws -> MaintenanceCategoryResponse
    func create(payload: MaintenanceCategoryCreateRequest) async throws -> MutationResponse
    func update(categoryID: String, payload: MaintenanceCategoryUpdateRequest) async throws -> MutationResponse
    func delete(categoryID: String) async throws -> MutationResponse
}
