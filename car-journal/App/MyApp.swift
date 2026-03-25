//
//  MyApp.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import SwiftUI

@main
@MainActor
struct MyApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                authManager: container.authManager,
                container: container
            )
        }
    }
}
