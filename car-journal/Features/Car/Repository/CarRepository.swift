//
//  AuthRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

protocol CarRepository {
    func list(page: Int) async throws -> PaginatedResponse<CarListResponse>
}

