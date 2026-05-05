//
//  MaintenanceEntryRepository.swift
//  car-journal
//

protocol MaintenanceEntryRepositoryProtocol {
    func list(carID: String, name: String?, sorts: String?, page: Int, limit: Int) async throws -> PaginatedResponse<MaintenanceEntryResponse>
    func findByID(entryID: String) async throws -> MaintenanceEntryResponse
    func create(carID: String, payload: MaintenanceEntryCreateRequest) async throws -> MutationResponse
    func update(entryID: String, payload: MaintenanceEntryUpdateRequest) async throws -> MutationResponse
    func delete(entryID: String) async throws -> MutationResponse
}
