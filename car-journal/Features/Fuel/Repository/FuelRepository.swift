//
//  FuelRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

protocol FuelRepositoryProtocol {
    func list(name: String, page: Int, limit: Int) async throws -> PaginatedResponse<FuelListResponse>
}
