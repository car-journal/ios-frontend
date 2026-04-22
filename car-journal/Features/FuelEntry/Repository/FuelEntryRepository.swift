//
//  FuelEntryRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

protocol FuelEntryRepositoryProtocol {
    func create(payload: FuelEntryCreateRequest) async throws -> MutationResponse
    func listByCarID(carID: String, page: Int, limit: Int) async throws -> PaginatedResponse<FuelEntryResponse>
    func findByID(fuelEntryID: String) async throws -> FuelEntryResponse
    func update(fuelEntryID: String, payload: FuelEntryUpdateRequest) async throws -> MutationResponse
}
