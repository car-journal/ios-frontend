//
//  CarDetailView.swift
//  car-journal
//
//  Created by 2297 on 26/03/26.
//

import SwiftUI

struct CarDetailView: View {
    let carID: String
    @StateObject private var viewModel: CarDetailViewModel
    
    init(carID: String, repository: CarRepository) {
        self.carID = carID
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
                
                FuelSummaryView(averageFuelConsumptionRate: viewModel.car?.averageFuelConsumptionRate ?? 0, recentFuelEntries: viewModel.car?.recentFuelEntries ?? [])
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
            repository: MockCarRepository()
        )
    }
}
