//
//  RegisterViewModel.swift
//  car-journal
//

import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didRegisterSuccessfully = false

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func register(
        email: String,
        password: String,
        confirmPassword: String,
        firstName: String,
        lastName: String,
        gender: Bool?,
        dateOfBirth: String?
    ) async {
        // FE validation
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty else {
            errorMessage = "Email, password and first name are required."
            return
        }
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let payload = RegisterRequest(
            clientSecret: AppConfig.clientSecret,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            gender: gender,
            firstName: firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            dateOfBirth: dateOfBirth?.isEmpty == false ? dateOfBirth : nil
        )

        do {
            let response = try await repository.register(payload: payload)
            didRegisterSuccessfully = response.success
        } catch {
            #if DEBUG
            print("error registering:", error)
            #endif
            errorMessage = "Registration failed. Please try again."
        }
    }
}
