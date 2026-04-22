//
//  MaintenanceEntryCreateView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceEntryCreateView: View {
    let carID: String
    @StateObject private var viewModel: MaintenanceViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(carID: String, maintenanceRepository: MaintenanceEntryRepositoryProtocol, categoryRepository: MaintenanceCategoryRepositoryProtocol) {
        self.carID = carID
        _viewModel = StateObject(wrappedValue: MaintenanceViewModel(repository: maintenanceRepository, categoryRepository: categoryRepository))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    formSection("Category", systemImage: "tag.fill") {
                        CategoryPickerField(
                            selectedID: $viewModel.form.categoryId,
                            selectedName: $viewModel.form.categoryName,
                            categories: viewModel.categories,
                            isLoading: viewModel.isLoadingCategories
                        )
                    }

                    formSection("Odometer", systemImage: "gauge.with.needle") {
                        AppField("Odometer Reading", text: $viewModel.form.odometerReading)
                            .keyboardType(.numberPad)
                        AppField("Reading Unit (km)", text: $viewModel.form.readingUnit)
                            .textInputAutocapitalization(.none)
                    }

                    formSection("Details", systemImage: "wrench.and.screwdriver.fill") {
                        AppField("Brand", text: $viewModel.form.brand)
                            .textInputAutocapitalization(.words)
                        AppField("Name", text: $viewModel.form.name)
                            .textInputAutocapitalization(.words)
                        AppField("Price (Rp)", text: $viewModel.form.price)
                            .keyboardType(.decimalPad)
                        DatePicker("Performed At", selection: $viewModel.form.performedAt, displayedComponents: .date)
                            .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput().tint(Color.appShade2)
                    }

                    formSection("Notes", systemImage: "note.text") {
                        AppField("Notes (optional)", text: $viewModel.form.notes)
                            .textInputAutocapitalization(.none)
                    }

                    if let error = viewModel.errorMessageForm {
                        Label(error, systemImage: "xmark.circle.fill")
                            .font(.appCaption).foregroundStyle(Color.appNegative)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 4)
                    }

                    AppButton(title: "Submit", isLoading: viewModel.isSubmitting) {
                        await viewModel.create(carID: carID)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("New Maintenance")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .task { await viewModel.loadCategories() }
        .onChange(of: viewModel.didCreateSuccessfully) { _, success in
            guard success else { return }
            Task { await carDetailViewModel.refresh(carID: carID) }
            dismiss()
        }
    }

    private func formSection<Content: View>(_ title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: systemImage).font(.appSubheadline).foregroundStyle(Color.appShade2)
                Text(title).font(.appHeadline).foregroundStyle(Color.cjTextPrimary)
            }.padding(.leading, 4)
            VStack(spacing: 10) { content() }.padding(16).appCard()
        }
    }
}
