//
//  CarCreateView.swift
//  car-journal
//

import SwiftUI

struct CarCreateView: View {
    let repository: CarRepositoryProtocol
    let onCreated: () -> Void
    @State private var form = CarEditForm()
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        formSection("Basic Info", systemImage: "car.fill") {
                            AppField("Brand", text: $form.brand)
                                .textInputAutocapitalization(.words)
                            AppField("Model", text: $form.model)
                                .textInputAutocapitalization(.words)
                            AppField("Manufacture Year", text: $form.manufactureYear)
                                .keyboardType(.numberPad)
                            AppField("Cylinder Capacity (cc)", text: $form.cylinderCapacity)
                                .keyboardType(.numberPad)
                            AppField("Color (optional)", text: $form.color)
                                .textInputAutocapitalization(.words)
                            AppField("Fuel Type", text: $form.fuelType)
                                .textInputAutocapitalization(.none)
                        }

                        formSection("Documents", systemImage: "doc.text.fill") {
                            AppField("VIN (optional)", text: $form.vehicleIdentityNumber)
                                .textInputAutocapitalization(.characters)
                            AppField("Engine Number (optional)", text: $form.engineNumber)
                                .textInputAutocapitalization(.characters)
                            AppField("Registration Year (optional)", text: $form.registrationYear)
                                .keyboardType(.numberPad)
                            AppField("Ownership Doc No. (optional)", text: $form.vehicleOwnershipDocumentNumber)
                                .textInputAutocapitalization(.characters)
                        }

                        if let error = errorMessage {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption)
                                .foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }

                        AppButton(title: "Create Car", isLoading: isSubmitting) {
                            await submit()
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Car")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
    }

    private func submit() async {
        if let error = form.validate() {
            errorMessage = error
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            let response = try await repository.create(payload: form.toCreateRequest())
            if response.success {
                onCreated()
                dismiss()
            }
        } catch {
            errorMessage = "Failed to create car. Please try again."
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
            VStack(spacing: 10) { content() }
                .padding(16)
                .appCard()
        }
    }
}

#Preview {
    CarCreateView(repository: MockCarRepository(), onCreated: {})
}
