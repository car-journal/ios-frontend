//
//  MockUserRepository.swift
//  car-journal
//

import Foundation

final class MockUserRepository: UserRepositoryProtocol {
    func me() async throws -> UserProfileResponse {
        UserProfileResponse(
            id: UUID(),
            roleId: "",
            email: "user@example.com",
            createdAt: Date(),
            updatedAt: Date(),
            firstName: "John",
            lastName: "Doe",
            pictureUrl: nil
        )
    }
    func updateProfile(payload: UpdateUserProfileRequest) async throws -> MutationResponse { MutationResponse(success: true) }
    func updatePassword(payload: UpdatePasswordRequest) async throws -> MutationResponse { MutationResponse(success: true) }
}
