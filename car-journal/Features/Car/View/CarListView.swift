//
//  CarListView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import SwiftUI

struct CarListView: View {
    @ObservedObject var authManager: AuthManager
    @StateObject private var viewModel: CarListViewModel
    
    init(authManager: AuthManager, repository: CarRepository) {
        self.authManager = authManager
        _viewModel = StateObject(wrappedValue: CarListViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading && viewModel.cars.isEmpty {
                        ForEach(0..<6, id: \.self) { _ in
                                CarSkeletonCard()
                        }
                    } else {
                        ForEach(viewModel.cars) { car in
                            CarCardView(car: car)
                                .onAppear {
                                    if car == viewModel.cars.last, !viewModel.isLoading, viewModel.hasNextPage {
                                        Task {
                                            await viewModel.fetchCars(page: viewModel.currentPage + 1)
                                        }
                                    }
                                }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.cars = []
                await viewModel.fetchCars(page: 1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("My Cars")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Logout") { authManager.logout() }
                }
            }
            .task {
                if viewModel.cars.isEmpty {
                    await viewModel.fetchCars(page: 1)
                }
            }
        }
    }
}

#Preview {
    CarListView(authManager: AuthManager(), repository: MockCarRepository())
}
