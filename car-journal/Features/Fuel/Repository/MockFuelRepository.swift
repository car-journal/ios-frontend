//
//  MockFuelRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

final class MockFuelRepository: FuelRepositoryProtocol {
    func list(name: String) async throws -> PaginatedResponse<FuelListResponse> {
        let mockFuels = FuelListResponse.mockFuels
        let meta = PaginationMeta(
            affectedRecords: mockFuels.count,
            lastPage: 2,
            count: mockFuels.count,
            hasNext: true
        )
        
        return PaginatedResponse(data: mockFuels, meta: meta)
    }
}
