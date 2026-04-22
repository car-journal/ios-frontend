//
//  ProfileViewModel.swift
//  car-journal
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: UserProfileResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Update profile form
    @Published var profileForm = ProfileForm()
    @Published var isUpdatingProfile = false
    @Published var didUpdateProfileSuccessfully = false
    @Published var errorMessageProfile: String?

    // Update password form
    @Published var passwordForm = PasswordForm()
    @Published var isUpdatingPassword = false
    @Published var didUpdatePasswordSuccessfully = false
    @Published var errorMessagePassword: String?

    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    struct ProfileForm {
        var firstName: String = ""
        var lastName: String = ""
        var gender: String = ""
        var dateOfBirth: String = ""
        var pictureUrl: String = ""
    }

    struct PasswordForm {
        var oldPassword: String = ""
        var newPassword: String = ""
        var confirmPassword: String = ""
    }

    func loadMe() async {
        guard user == nil else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await repository.me()
            user = response
            profileForm.firstName = response.firstName
            profileForm.lastName = response.lastName ?? ""
            profileForm.pictureUrl = response.pictureUrl ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateProfile() async {
        guard !profileForm.firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessageProfile = "First name is required"; return
        }
        isUpdatingProfile = true; errorMessageProfile = nil
        defer { isUpdatingProfile = false }
        do {
            let payload = UpdateUserProfileRequest(
                gender: profileForm.gender.isEmpty ? nil : profileForm.gender,
                firstName: profileForm.firstName,
                lastName: profileForm.lastName.isEmpty ? nil : profileForm.lastName,
                dateOfBirth: profileForm.dateOfBirth.isEmpty ? nil : profileForm.dateOfBirth,
                pictureUrl: profileForm.pictureUrl.isEmpty ? nil : profileForm.pictureUrl
            )
            let response = try await repository.updateProfile(payload: payload)
            if response.success {
                didUpdateProfileSuccessfully = true
                user = nil
                await loadMe()
            }
        } catch {
            errorMessageProfile = "Failed to update profile. Please try again."
        }
    }

    func updatePassword() async {
        // Validate
        if passwordForm.oldPassword.isEmpty { errorMessagePassword = "Current password is required"; return }
        if passwordForm.newPassword.count < 6 { errorMessagePassword = "New password must be at least 6 characters"; return }
        if passwordForm.newPassword.count > 25 { errorMessagePassword = "New password must be at most 25 characters"; return }
        if passwordForm.newPassword != passwordForm.confirmPassword { errorMessagePassword = "Passwords do not match"; return }

        isUpdatingPassword = true; errorMessagePassword = nil
        defer { isUpdatingPassword = false }
        do {
            let payload = UpdatePasswordRequest(
                oldPassword: passwordForm.oldPassword,
                newPassword: passwordForm.newPassword,
                newPasswordConfirmation: passwordForm.confirmPassword
            )
            let response = try await repository.updatePassword(payload: payload)
            if response.success {
                didUpdatePasswordSuccessfully = true
                passwordForm = PasswordForm()
            }
        } catch {
            errorMessagePassword = "Failed to update password. Please try again."
        }
    }
}
