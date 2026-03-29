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
        NavigationStack {
            if authManager.isLoggedIn {
                CarListView(
                    authManager: authManager,
                    fuelEntryRepository: container.fuelEntryRepository,
                    repository: container.carRepository
                )
            } else {
                LoginView(
                    viewModel: LoginViewModel(
                        authManager: container.authManager,
                        repository: container.authRepository
                    )
                )
            }
        }
    }
}
