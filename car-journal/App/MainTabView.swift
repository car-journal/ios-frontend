//
//  MainTabView.swift
//  car-journal
//

import SwiftUI

enum AppTab: Int {
    case categories = 0
    case home       = 1
    case profile    = 2
}

struct MainTabView: View {
    @ObservedObject var authManager: AuthManager
    let container: AppContainer
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            // Categories tab
            MaintenanceCategoryListView(repository: container.maintenanceCategoryRepository)
                .tabItem { Label("Categories", systemImage: "tag.fill") }
                .tag(AppTab.categories)

            // Home tab
            CarListView(
                authManager: authManager,
                fuelRepository: container.fuelRepository,
                fuelEntryRepository: container.fuelEntryRepository,
                maintenanceRepository: container.maintenanceEntryRepository,
                categoryRepository: container.maintenanceCategoryRepository,
                repository: container.carRepository
            )
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(AppTab.home)

            // Profile tab
            ProfileView(
                authManager: authManager,
                userRepository: container.userRepository
            )
            .tabItem { Label("Profile", systemImage: "person.fill") }
            .tag(AppTab.profile)
        }
        .tint(Color.cjPrimary)
    }
}
