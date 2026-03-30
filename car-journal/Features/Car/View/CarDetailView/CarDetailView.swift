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
    @StateObject private var viewModel: CarDetailViewModel
    
    init(carID: String, fuelRepository: FuelRepositoryProtocol,  fuelEntryRepository: FuelEntryRepositoryProtocol, repository: CarRepositoryProtocol) {
        self.carID = carID
        self.fuelRepository = fuelRepository
        self.fuelEntryRepository = fuelEntryRepository
        _viewModel = StateObject(wrappedValue: CarDetailViewModel(repository: repository))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isLoading {
                    CarSkeletonCard()
                    CarSkeletonCard()
                } else if let car = viewModel.car {
                    CarDetailCardView(car: car)
                    FuelSummaryView(averageFuelConsumptionRate: car.averageFuelConsumptionRate, carID: carID, fuelRepository: fuelRepository, recentFuelEntries: car.recentFuelEntries, repository: fuelEntryRepository)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
        }
        .environmentObject(viewModel)
        .navigationTitle(
            viewModel.car.map { "\($0.brand) \($0.model)" } ?? "Car Detail"
        )
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
            repository: MockCarRepository()
        )
    }
}
