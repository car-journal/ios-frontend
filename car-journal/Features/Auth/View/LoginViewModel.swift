//
//  LoginViewModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 24/03/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authManager: AuthManager
    private let repository: AuthRepository
    
    init(authManager: AuthManager, repository: AuthRepository) {
        self.repository = repository
        self.authManager = authManager
    }
    
    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all the fields."
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let response = try await repository.login(
                email: email,
                password: password
            )
            
            let token = AuthToken(
                accessToken: response.accessToken,
                expiresAt: response.expiresAt,
                tokenType: response.tokenType
            )
            
            authManager.saveToken(token)
            
        } catch let error {
            print("error in logging in:", error)
            errorMessage = "Failed to login. Please try again later."
        }
    }
}
