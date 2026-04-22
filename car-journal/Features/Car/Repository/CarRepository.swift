//
//  AuthRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

protocol CarRepositoryProtocol {
    func list(page: Int) async throws -> PaginatedResponse<CarListResponse>
    func findByID(carID: String) async throws -> CarDetailResponse
    func update(carID: String, payload: CarUpdateRequest) async throws -> MutationResponse
}

