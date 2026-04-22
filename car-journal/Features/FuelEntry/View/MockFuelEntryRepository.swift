//
//  MockFuelEntryRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

final class MockFuelEntryRepository: FuelEntryRepositoryProtocol {
    func listByCarID(carID: String, page: Int, limit: Int) async throws -> PaginatedResponse<FuelEntryResponse> {
        let fuelEntries = FuelEntryResponse.mockFuelEntries
        let meta = PaginationMeta(
            affectedRecords: FuelEntryResponse.mockFuelEntries.count,
            lastPage: 2,
            count: FuelEntryResponse.mockFuelEntries.count,
            hasNext: true
        )
        return PaginatedResponse(data: fuelEntries, meta: meta)
    }
    
    func create(payload: FuelEntryCreateRequest) async throws -> MutationResponse {
        return MutationResponse(success: true)
    }
    
    func findByID(fuelEntryID: String) async throws -> FuelEntryResponse {
        let fuelEntry = FuelEntryResponse.mockFuelEntry
        return fuelEntry
    }
    
    func update(fuelEntryID: String, payload: FuelEntryUpdateRequest) async throws -> MutationResponse {
        return MutationResponse(success: true)
    }
}
