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
    @State private var isShowingCreate = false
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    let maintenanceRepository: MaintenanceEntryRepositoryProtocol
    let categoryRepository: MaintenanceCategoryRepositoryProtocol
    let repository: CarRepositoryProtocol

    init(
        authManager: AuthManager,
        fuelRepository: FuelRepositoryProtocol,
        fuelEntryRepository: FuelEntryRepositoryProtocol,
        maintenanceRepository: MaintenanceEntryRepositoryProtocol,
        categoryRepository: MaintenanceCategoryRepositoryProtocol,
        repository: CarRepositoryProtocol
    ) {
        self.authManager = authManager
        self.fuelRepository = fuelRepository
        self.fuelEntryRepository = fuelEntryRepository
        self.maintenanceRepository = maintenanceRepository
        self.categoryRepository = categoryRepository
        self.repository = repository
        _viewModel = StateObject(wrappedValue: CarListViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 14) {
                        if viewModel.isLoading && viewModel.cars.isEmpty {
                            ForEach(0..<5, id: \.self) { _ in CarSkeletonCard() }
                        } else if let error = viewModel.error, viewModel.cars.isEmpty {
                            errorState(message: error)
                        } else if viewModel.cars.isEmpty && !viewModel.isLoading {
                            emptyState
                        } else {
                            ForEach(viewModel.cars) { car in
                                NavigationLink(value: car.id) {
                                    CarCardView(car: car)
                                        .onAppear {
                                            if car == viewModel.cars.last,
                                               !viewModel.isLoading,
                                               viewModel.hasNextPage {
                                                Task { await viewModel.fetchCars(page: viewModel.currentPage + 1) }
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                            if viewModel.isLoading {
                                ProgressView().tint(Color.appShade2).padding()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .refreshable {
                    viewModel.cars = []
                    await viewModel.fetchCars(page: 1)
                }
            }
            .navigationTitle("My Cars")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreate = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.appSubheadline)
                            .foregroundStyle(Color.cjPrimary)
                    }
                }
            }
            .sheet(isPresented: $isShowingCreate) {
                CarCreateView(repository: repository) {
                    viewModel.cars = []
                    viewModel.hasNextPage = true
                    Task { await viewModel.fetchCars(page: 1) }
                }
            }
            .navigationDestination(for: UUID.self) { carID in
                CarDetailView(
                    carID: carID.uuidString,
                    fuelRepository: fuelRepository,
                    fuelEntryRepository: fuelEntryRepository,
                    maintenanceRepository: maintenanceRepository,
                    categoryRepository: categoryRepository,
                    repository: repository
                )
            }
            .task {
                if viewModel.cars.isEmpty {
                    await viewModel.fetchCars(page: 1)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "car.2").font(.system(size: 48)).foregroundStyle(Color.appShade1)
            Text("No cars yet").font(.appTitle2).foregroundStyle(Color.cjTextPrimary)
            Text("Add your first car to get started.").font(.appSubheadline).foregroundStyle(Color.cjTextSecondary).multilineTextAlignment(.center)
        }
        .padding(.top, 80)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(Color.appNegative)
            Text("Failed to load cars")
                .font(.appTitle2)
                .foregroundStyle(Color.cjTextPrimary)
            Text(message)
                .font(.appSubheadline)
                .foregroundStyle(Color.cjTextSecondary)
                .multilineTextAlignment(.center)
            Button {
                Task {
                    viewModel.error = nil
                    viewModel.hasNextPage = true
                    await viewModel.fetchCars(page: 1)
                }
            } label: {
                Text("Retry")
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.cjOnPrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.cjPrimary)
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 80)
        .padding(.horizontal, 32)
    }
}

#Preview {
    CarListView(
        authManager: AuthManager(),
        fuelRepository: MockFuelRepository(),
        fuelEntryRepository: MockFuelEntryRepository(),
        maintenanceRepository: MockMaintenanceEntryRepository(),
        categoryRepository: MockMaintenanceCategoryRepository(),
        repository: MockCarRepository()
    )
}
