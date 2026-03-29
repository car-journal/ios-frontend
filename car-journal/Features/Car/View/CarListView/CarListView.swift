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
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    let repository: CarRepositoryProtocol
    
    init(authManager: AuthManager, fuelEntryRepository: FuelEntryRepositoryProtocol, repository: CarRepositoryProtocol) {
        self.authManager = authManager
        self.fuelEntryRepository = fuelEntryRepository
        self.repository = repository
        _viewModel = StateObject(wrappedValue: CarListViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16, pinnedViews: []) {
                    if viewModel.isLoading && viewModel.cars.isEmpty {
                        ForEach(0..<6, id: \.self) { _ in
                                CarSkeletonCard()
                        }
                    } else {
                        ForEach(viewModel.cars) { car in
                            NavigationLink(value: car.id) {
                                CarCardView(car: car)
                                    .onAppear {
                                        if car == viewModel.cars.last, !viewModel.isLoading, viewModel.hasNextPage {
                                            Task {
                                                await viewModel.fetchCars(page: viewModel.currentPage + 1)
                                            }
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
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
            .navigationDestination(for: UUID.self) { carID in
                CarDetailView(
                    carID: carID.uuidString,
                    fuelEntryRepository: fuelEntryRepository,
                    repository: repository
                )
            }
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
    CarListView(authManager: AuthManager(), fuelEntryRepository: MockFuelEntryRepository(), repository: MockCarRepository())
}
