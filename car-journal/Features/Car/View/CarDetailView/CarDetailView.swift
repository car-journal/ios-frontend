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
                } else if let car = viewModel.car {
                    CarDetailCardView(car: car)
                }
                
                FuelSummaryView(averageFuelConsumptionRate: viewModel.car?.averageFuelConsumptionRate ?? 0, carID: carID, fuelRepository: fuelRepository, recentFuelEntries: viewModel.car?.recentFuelEntries ?? [], repository: fuelEntryRepository)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
        }
        .navigationTitle(
            viewModel.car.map { "\($0.brand) \($0.model)" } ?? "Car Detail"
        )
        .task(id: carID) {
            await viewModel.findByID(carID: carID)
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
