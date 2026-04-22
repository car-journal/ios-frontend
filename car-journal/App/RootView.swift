//
//  RootView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var authManager: AuthManager
    let container: AppContainer

    var body: some View {
        ThemeAwareRootView(authManager: authManager, container: container)
    }
}

private struct ThemeAwareRootView: View {
    @ObservedObject var authManager: AuthManager
    @StateObject private var themeManager = ThemeManager.shared
    let container: AppContainer

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                MainTabView(authManager: authManager, container: container)
            } else {
                LoginView(
                    viewModel: LoginViewModel(
                        authManager: container.authManager,
                        repository: container.authRepository
                    )
                )
            }
        }
        .preferredColorScheme(themeManager.mode.colorScheme)
    }
}
