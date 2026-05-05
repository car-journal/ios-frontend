//
//  MockCarRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

final class MockCarRepository: CarRepositoryProtocol {
    func list(page: Int) async throws -> PaginatedResponse<CarListResponse> {
        let mockCars: [CarListResponse]
        let meta: PaginationMeta

        switch page {
        case 1:
            mockCars = CarListResponse.mockCarsFirstPage
            meta = PaginationMeta(
                affectedRecords: mockCars.count,
                lastPage: 2,
                count: mockCars.count,
                hasNext: true
            )
        case 2:
            mockCars = CarListResponse.mockCarsSecondPage
            meta = PaginationMeta(
                affectedRecords: mockCars.count,
                lastPage: 2,
                count: mockCars.count,
                hasNext: false
            )
        default:
            mockCars = []
            meta = PaginationMeta(
                affectedRecords: 0,
                lastPage: 2,
                count: 0,
                hasNext: false
            )
        }

        return PaginatedResponse(data: mockCars, meta: meta)
    }
    
    func findByID(carID: String) async throws -> CarDetailResponse {
        let mockCar: CarDetailResponse = CarDetailResponse.mockCar
        return mockCar
    }
    
    func update(carID: String, payload: CarUpdateRequest) async throws -> MutationResponse {
        return MutationResponse(success: true)
    }
    
    func create(payload: CarCreateRequest) async throws -> MutationResponse {
        return MutationResponse(success: true)
    }
}
