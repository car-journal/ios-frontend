//
//  FuelEntryCreateView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import SwiftUI

struct FuelEntryCreateView: View {
    @StateObject private var viewModel: FuelEntryViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(carID: String, fuelRepository: FuelRepositoryProtocol, repository: FuelEntryRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: FuelEntryViewModel(
            carID: carID,
            fuelRepository: fuelRepository,
            repository: repository
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                formSection
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                AppButton(
                    title: "Submit",
                    isLoading: viewModel.isLoading
                ) {
                    await viewModel.create()
                }
            }
            .padding()
        }
        .navigationTitle("New Fuel Entry")
        .onChange(of: viewModel.didCreateSuccessfully) { _, success in
            guard success else { return }
            Task {
                await carDetailViewModel.refresh(carID: viewModel.carID)
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        FuelEntryCreateView(carID: "", fuelRepository: MockFuelRepository(), repository: MockFuelEntryRepository())
    }
}

private extension FuelEntryCreateView {
    var formSection: some View {
        VStack(spacing: 16) {
            TextField("Odometer Reading", text: $viewModel.odometerReading)
                .keyboardType(.numberPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Reading Unit (km)", text: $viewModel.readingUnit)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Type", text: $viewModel.fuelType)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Brand", text: $viewModel.fuelBrand)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            FuelNameDropdown(fuelName: $viewModel.fuelName, viewModel: viewModel)
            
            TextField("Fuel Price (Rp)", text: $viewModel.fuelPrice)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Unit (liter)", text: $viewModel.fuelUnit)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Distance Traveled", text: $viewModel.distanceTraveled)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Volume Filled (liter)", text: $viewModel.volumeFilled)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Notes (optional)", text: $viewModel.notes)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}
