//
//  AuthManager.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation
import Combine

@MainActor
final class AuthManager: ObservableObject {

    static let shared = AuthManager()

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
}
