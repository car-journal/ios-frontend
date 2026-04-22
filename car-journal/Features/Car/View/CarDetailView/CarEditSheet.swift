//
//  CarEditSheet.swift
//  car-journal
//
//  Created by Kiro on 21/04/26.
//

import SwiftUI

struct CarEditSheet: View {
    @EnvironmentObject var viewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        formSection("Basic Info", systemImage: "car.fill") {
                            AppField("Brand", text: $viewModel.editForm.brand)
                                .textInputAutocapitalization(.words)
                            AppField("Model", text: $viewModel.editForm.model)
                                .textInputAutocapitalization(.words)
                            AppField("Manufacture Year", text: $viewModel.editForm.manufactureYear)
                                .keyboardType(.numberPad)
                            AppField("Color", text: $viewModel.editForm.color)
                                .textInputAutocapitalization(.words)
                            AppField("Fuel Type", text: $viewModel.editForm.fuelType)
                                .textInputAutocapitalization(.none)
                            AppField("Cylinder Capacity (cc)", text: $viewModel.editForm.cylinderCapacity)
                                .keyboardType(.numberPad)
                        }

                        formSection("Documents", systemImage: "doc.text.fill") {
                            AppField("VIN (optional)", text: $viewModel.editForm.vehicleIdentityNumber)
                                .textInputAutocapitalization(.characters)
                            AppField("Engine Number (optional)", text: $viewModel.editForm.engineNumber)
                                .textInputAutocapitalization(.characters)
                            AppField("Registration Year (optional)", text: $viewModel.editForm.registrationYear)
                                .keyboardType(.numberPad)
                            AppField("Ownership Doc No. (optional)", text: $viewModel.editForm.vehicleOwnershipDocumentNumber)
                                .textInputAutocapitalization(.characters)
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
                            isLoading: viewModel.isUpdating,
                            isDisabled: viewModel.car == nil
                        ) {
                            guard let carID = viewModel.car?.id.uuidString else { return }
                            await viewModel.update(carID: carID)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Car")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
        .onChange(of: viewModel.didUpdateSuccessfully) { _, success in
            guard success else { return }
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

// MARK: - Reusable labelled text field
struct AppField: View {
    let placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.appBody)
            .foregroundStyle(Color.cjTextPrimary)
            .appInput()
    }
}

#Preview {
    CarEditSheet()
        .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
}
