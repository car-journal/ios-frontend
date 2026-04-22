//
//  FuelEntryDetailView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 31/03/26.
//

import SwiftUI

struct FuelEntryDetailView: View {
    let carID: String
    let fuelEntryID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    @StateObject private var viewModel: FuelEntryViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        carID: String,
        fuelEntryID: String,
        fuelRepository: FuelRepositoryProtocol,
        fuelEntryRepository: FuelEntryRepositoryProtocol
    ) {
        self.carID = carID
        self.fuelEntryID = fuelEntryID
        self.fuelEntryRepository = fuelEntryRepository
        self.fuelRepository = fuelRepository
        _viewModel = StateObject(wrappedValue: FuelEntryViewModel(
            carID: carID,
            fuelRepository: fuelRepository,
            repository: fuelEntryRepository
        ))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()

            if viewModel.isLoadingFindByID && viewModel.fuelEntry == nil {
                ProgressView()
                    .tint(Color.appShade2)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        formSection("Odometer", systemImage: "gauge.with.needle") {
                            AppField("Odometer Reading", text: $viewModel.editForm.odometerReading)
                                .keyboardType(.numberPad)
                            AppField("Reading Unit (km)", text: $viewModel.editForm.readingUnit)
                                .textInputAutocapitalization(.none)
                        }

                        formSection("Fuel", systemImage: "fuelpump.fill") {
                            FuelNameDropdown(
                                fuelName: $viewModel.editForm.fuelName,
                                fuelType: $viewModel.editForm.fuelType,
                                fuelBrand: $viewModel.editForm.fuelBrand,
                                fuelPrice: $viewModel.editForm.fuelPrice,
                                viewModel: viewModel
                            )
                            AppField("Fuel Type", text: $viewModel.editForm.fuelType)
                                .textInputAutocapitalization(.none)
                            AppField("Fuel Brand", text: $viewModel.editForm.fuelBrand)
                                .textInputAutocapitalization(.none)
                            AppField("Fuel Price (Rp)", text: $viewModel.editForm.fuelPrice)
                                .keyboardType(.decimalPad)
                            AppField("Fuel Unit (liter)", text: $viewModel.editForm.fuelUnit)
                                .textInputAutocapitalization(.none)
                        }

                        formSection("Fill-up Details", systemImage: "drop.fill") {
                            AppField("Volume Filled (liter)", text: $viewModel.editForm.volumeFilled)
                                .keyboardType(.decimalPad)
                            AppField("Distance Traveled (km)", text: $viewModel.editForm.distanceTraveled)
                                .keyboardType(.decimalPad)

                            DatePicker(
                                "Filled At",
                                selection: $viewModel.editForm.filledAt,
                                displayedComponents: .date
                            )
                            .font(.appBody)
                            .foregroundStyle(Color.cjTextPrimary)
                            .appInput()
                            .tint(Color.appShade2)
                        }

                        formSection("Notes", systemImage: "note.text") {
                            AppField("Notes (optional)", text: $viewModel.editForm.notes)
                                .textInputAutocapitalization(.none)
                        }

                        if let error = viewModel.errorMessageUpdate {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption)
                                .foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }

                        AppButton(
                            title: "Save Changes",
                            isLoading: viewModel.isUpdating
                        ) {
                            await viewModel.update(fuelEntryID: fuelEntryID)
                        }
                        .disabled(viewModel.isUpdating)
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Edit Fuel Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .task {
            await viewModel.findByID(fuelEntryID: fuelEntryID)
        }
        .onChange(of: viewModel.didUpdateSuccessfully) { _, success in
            guard success else { return }
            Task { await carDetailViewModel.refresh(carID: carID) }
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

// MARK: - Legacy support (kept for backward compat)
struct DetailCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.appHeadline)
                .foregroundStyle(Color.cjTextPrimary)
            VStack(spacing: 12) { content }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundStyle(Color.cjTextSecondary)
            Text(label)
                .font(.appSubheadline)
                .foregroundStyle(Color.cjTextSecondary)
            Spacer()
            Text(value)
                .font(.appSubheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.cjTextPrimary)
        }
    }
}

#Preview {
    NavigationStack {
        FuelEntryDetailView(
            carID: "",
            fuelEntryID: "",
            fuelRepository: MockFuelRepository(),
            fuelEntryRepository: MockFuelEntryRepository()
        )
        .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
    }
}
