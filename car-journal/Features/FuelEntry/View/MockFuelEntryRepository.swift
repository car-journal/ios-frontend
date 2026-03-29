//
//  MockFuelEntryRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

final class MockFuelEntryRepository: FuelEntryRepositoryProtocol {
    func create(payload: FuelEntryCreateRequest) async throws -> MutationResponse {
        let mockFuelEntry = FuelEntryCreateRequest.mockFuelEntry
        return MutationResponse(success: true)
    }
}
