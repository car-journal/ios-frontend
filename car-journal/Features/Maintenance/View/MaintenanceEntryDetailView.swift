//
//  MaintenanceEntryDetailView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceEntryDetailView: View {
    let entry: MaintenanceEntryResponse
    let carID: String
    @StateObject private var viewModel: MaintenanceViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirm = false

    init(entry: MaintenanceEntryResponse, carID: String, maintenanceRepository: MaintenanceEntryRepositoryProtocol, categoryRepository: MaintenanceCategoryRepositoryProtocol) {
        self.entry = entry
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
                        AppField("Brand", text: $viewModel.form.brand).textInputAutocapitalization(.words)
                        AppField("Name", text: $viewModel.form.name).textInputAutocapitalization(.words)
                        AppField("Price (Rp)", text: $viewModel.form.price).keyboardType(.decimalPad)
                        DatePicker("Performed At", selection: $viewModel.form.performedAt, displayedComponents: .date)
                            .font(.appBody).foregroundStyle(Color.cjTextPrimary).appInput().tint(Color.appShade2)
                    }

                    formSection("Notes", systemImage: "note.text") {
                        AppField("Notes (optional)", text: $viewModel.form.notes).textInputAutocapitalization(.none)
                    }

                    if let error = viewModel.errorMessageForm {
                        Label(error, systemImage: "xmark.circle.fill")
                            .font(.appCaption).foregroundStyle(Color.appNegative)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 4)
                    }

                    AppButton(title: "Save Changes", isLoading: viewModel.isSubmitting) {
                        await viewModel.update(entryID: entry.id.uuidString)
                    }

                    // Delete button
                    Button {
                        showDeleteConfirm = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "trash")
                            Text("Delete Entry")
                        }
                        .font(.appSubheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.appNegative)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.appNegative.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Edit Maintenance")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .task {
            viewModel.form = MaintenanceEntryForm(from: entry)
            await viewModel.loadCategories()
            // Set category name from loaded categories
            if let cat = viewModel.categories.first(where: { $0.id.uuidString == entry.categoryId.uuidString }) {
                viewModel.form.categoryName = cat.name
            }
        }
        .onChange(of: viewModel.didUpdateSuccessfully) { _, success in
            guard success else { return }
            Task { await carDetailViewModel.refresh(carID: carID) }
            dismiss()
        }
        .onChange(of: viewModel.didDeleteSuccessfully) { _, success in
            guard success else { return }
            Task { await carDetailViewModel.refresh(carID: carID) }
            dismiss()
        }
        .confirmationDialog("Delete this maintenance entry?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await viewModel.delete(entryID: entry.id.uuidString) }
            }
            Button("Cancel", role: .cancel) {}
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
