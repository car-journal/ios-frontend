//
//  AuthManager.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation
import Combine

final class AuthManager: ObservableObject {
    @Published private(set) var token: AuthToken?

    private let tokenStore: TokenStore

    init(tokenStore: TokenStore = TokenStore()) {
        self.tokenStore = tokenStore
        self.token = tokenStore.load()
    }

    var isLoggedIn: Bool {
        token != nil
    }

    func saveToken(_ token: AuthToken) {
        do {
            try tokenStore.save(token)
            self.token = token
        } catch let error {
            print("Failed to save token:", error)
        }
    }

    func logout() {
        tokenStore.clear()
        token = nil
    }

    func getAccessToken() -> String? {
        token?.accessToken
    }
    
    func requireAccessToken() throws -> String {
        guard let token = getAccessToken() else {
            #if DEBUG
            print("No access token, user is not logged in")
            #endif
            throw AuthManagerError.noAccessToken
        }
        
        return token
    }
}
