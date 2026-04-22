//
//  UserRepository.swift
//  car-journal
//

protocol UserRepositoryProtocol {
    func me() async throws -> UserProfileResponse
    func updateProfile(payload: UpdateUserProfileRequest) async throws -> MutationResponse
    func updatePassword(payload: UpdatePasswordRequest) async throws -> MutationResponse
}
