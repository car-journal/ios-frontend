//
//  MockAuthRepository.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 24/03/26.
//

import Foundation

final class MockAuthRepository: AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> LoginResponse {
        return LoginResponse(
            accessToken: "mock_access_token_123",
            expiresAt: Date().addingTimeInterval(3600),
            tokenType: "Bearer"
        )
    }

    func register(payload: RegisterRequest) async throws -> MutationResponse {
        return MutationResponse(success: true)
    }
}
