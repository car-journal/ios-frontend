//
//  MaintenanceCategoryDetailView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceCategoryDetailView: View {
    let category: MaintenanceCategoryResponse
    let repository: MaintenanceCategoryRepositoryProtocol
    let onRefresh: () -> Void
    @StateObject private var viewModel: MaintenanceCategoryViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirm = false

    init(category: MaintenanceCategoryResponse, repository: MaintenanceCategoryRepositoryProtocol, onRefresh: @escaping () -> Void) {
        self.category = category
        self.repository = repository
        self.onRefresh = onRefresh
        _viewModel = StateObject(wrappedValue: MaintenanceCategoryViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    AppField("Name", text: $viewModel.form.name).textInputAutocapitalization(.words)
                    AppField("Description (optional)", text: $viewModel.form.description).textInputAutocapitalization(.sentences)

                    if let error = viewModel.errorMessageForm {
                        Label(error, systemImage: "xmark.circle.fill")
                            .font(.appCaption).foregroundStyle(Color.appNegative)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    AppButton(title: "Save Changes", isLoading: viewModel.isSubmitting) {
                        await viewModel.update(categoryID: category.id.uuidString)
                    }

                    Button {
                        showDeleteConfirm = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "trash")
                            Text("Delete Category")
                        }
                        .font(.appSubheadline).fontWeight(.semibold).foregroundStyle(Color.appNegative)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Color.appNegative.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Edit Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .onAppear {
            viewModel.form.name = category.name
            viewModel.form.description = category.description ?? ""
        }
        .onChange(of: viewModel.didUpdateSuccessfully) { _, success in
            guard success else { return }
            onRefresh(); dismiss()
        }
        .onChange(of: viewModel.didDeleteSuccessfully) { _, success in
            guard success else { return }
            onRefresh(); dismiss()
        }
        .confirmationDialog("Delete this category?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await viewModel.delete(categoryID: category.id.uuidString) }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
