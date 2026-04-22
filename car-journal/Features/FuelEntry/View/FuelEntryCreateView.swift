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
        ZStack {
            Color.cjBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    formSection("Odometer", systemImage: "gauge.with.needle") {
                        AppField("Odometer Reading", text: $viewModel.form.odometerReading)
                            .keyboardType(.numberPad)
                        AppField("Reading Unit (km)", text: $viewModel.form.readingUnit)
                            .textInputAutocapitalization(.none)
                    }

                    formSection("Fuel", systemImage: "fuelpump.fill") {
                        FuelNameDropdown(
                            fuelName: $viewModel.form.fuelName,
                            fuelType: $viewModel.form.fuelType,
                            fuelBrand: $viewModel.form.fuelBrand,
                            fuelPrice: $viewModel.form.fuelPrice,
                            viewModel: viewModel
                        )
                        AppField("Fuel Type", text: $viewModel.form.fuelType)
                            .textInputAutocapitalization(.none)
                        AppField("Fuel Brand", text: $viewModel.form.fuelBrand)
                            .textInputAutocapitalization(.none)
                        AppField("Fuel Price (Rp)", text: $viewModel.form.fuelPrice)
                            .keyboardType(.decimalPad)
                        AppField("Fuel Unit (liter)", text: $viewModel.form.fuelUnit)
                            .textInputAutocapitalization(.none)
                    }

                    formSection("Fill-up Details", systemImage: "drop.fill") {
                        AppField("Volume Filled (liter)", text: $viewModel.form.volumeFilled)
                            .keyboardType(.decimalPad)
                        AppField("Distance Traveled (km)", text: $viewModel.form.distanceTraveled)
                            .keyboardType(.decimalPad)

                        DatePicker(
                            "Filled At",
                            selection: $viewModel.form.filledAt,
                            displayedComponents: .date
                        )
                        .font(.appBody)
                        .foregroundStyle(Color.cjTextPrimary)
                        .appInput()
                        .tint(Color.appShade2)
                    }

                    formSection("Notes", systemImage: "note.text") {
                        AppField("Notes (optional)", text: $viewModel.form.notes)
                            .textInputAutocapitalization(.none)
                    }

                    if let error = viewModel.errorMessage {
                        Label(error, systemImage: "xmark.circle.fill")
                            .font(.appCaption)
                            .foregroundStyle(Color.appNegative)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }

                    AppButton(
                        title: "Submit",
                        isLoading: viewModel.isLoading
                    ) {
                        await viewModel.create()
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("New Fuel Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .onChange(of: viewModel.didCreateSuccessfully) { _, success in
            guard success else { return }
            Task { await carDetailViewModel.refresh(carID: viewModel.carID) }
            dismiss()
        }
    }

    private func formSection<Content: View>(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.appSubheadline)
                    .foregroundStyle(Color.appShade2)
                Text(title)
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
            }
            .padding(.leading, 4)

            VStack(spacing: 10) {
                content()
            }
            .padding(16)
            .appCard()
        }
    }
}

#Preview {
    NavigationStack {
        FuelEntryCreateView(carID: "", fuelRepository: MockFuelRepository(), repository: MockFuelEntryRepository())
            .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
    }
}
