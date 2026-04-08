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
            TextField("Odometer Reading", text: $viewModel.form.odometerReading)
                .keyboardType(.numberPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Reading Unit (km)", text: $viewModel.form.readingUnit)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Type", text: $viewModel.form.fuelType)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Brand", text: $viewModel.form.fuelBrand)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            FuelNameDropdown(fuelName: $viewModel.form.fuelName, viewModel: viewModel)
            
            TextField("Fuel Price (Rp)", text: $viewModel.form.fuelPrice)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Fuel Unit (liter)", text: $viewModel.form.fuelUnit)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Distance Traveled", text: $viewModel.form.distanceTraveled)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            TextField("Volume Filled (liter)", text: $viewModel.form.volumeFilled)
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            DatePicker(
                "Filled At",
                selection: $viewModel.form.filledAt,
                displayedComponents: .date
            )
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            TextField("Notes (optional)", text: $viewModel.form.notes)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}
