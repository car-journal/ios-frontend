//
//  CarDetailView.swift
//  car-journal
//
//  Created by 2297 on 26/03/26.
//

import SwiftUI

struct CarDetailView: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    let maintenanceRepository: MaintenanceEntryRepositoryProtocol
    let categoryRepository: MaintenanceCategoryRepositoryProtocol
    @StateObject private var viewModel: CarDetailViewModel

    init(
        carID: String,
        fuelRepository: FuelRepositoryProtocol,
        fuelEntryRepository: FuelEntryRepositoryProtocol,
        maintenanceRepository: MaintenanceEntryRepositoryProtocol,
        categoryRepository: MaintenanceCategoryRepositoryProtocol,
        repository: CarRepositoryProtocol
    ) {
        self.carID = carID
        self.fuelRepository = fuelRepository
        self.fuelEntryRepository = fuelEntryRepository
        self.maintenanceRepository = maintenanceRepository
        self.categoryRepository = categoryRepository
        _viewModel = StateObject(wrappedValue: CarDetailViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading && viewModel.car == nil {
                        CarSkeletonCard()
                        CarSkeletonCard()
                    } else if let car = viewModel.car {
                        CarDetailCardView(car: car)
                        FuelSummaryView(
                            carID: carID,
                            fuelRepository: fuelRepository,
                            fuelSummary: car.fuelSummary,
                            repository: fuelEntryRepository
                        )
                        MaintenanceSummaryView(
                            carID: carID,
                            maintenanceSummary: car.maintenanceSummary,
                            maintenanceRepository: maintenanceRepository,
                            categoryRepository: categoryRepository
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .environmentObject(viewModel)
        .navigationTitle(viewModel.car.map { "\($0.brand) \($0.model)" } ?? "Car Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .task {
            await viewModel.initialLoad(carID: carID)
        }
        .refreshable {
            await viewModel.refresh(carID: carID)
        }
    }
}

#Preview {
    NavigationStack {
        CarDetailView(
            carID: UUID().uuidString,
            fuelRepository: MockFuelRepository(),
            fuelEntryRepository: MockFuelEntryRepository(),
            maintenanceRepository: MockMaintenanceEntryRepository(),
            categoryRepository: MockMaintenanceCategoryRepository(),
            repository: MockCarRepository()
        )
    }
}
