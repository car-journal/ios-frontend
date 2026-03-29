//
//  FuelEntryRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

protocol FuelEntryRepositoryProtocol {
    func create(payload: FuelEntryCreateRequest) async throws -> MutationResponse
}
