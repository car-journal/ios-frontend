//
//  AuthRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> LoginResponse
}


