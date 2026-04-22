//
//  MaintenanceCategoryListView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceCategoryListView: View {
    let repository: MaintenanceCategoryRepositoryProtocol
    @StateObject private var viewModel: MaintenanceCategoryViewModel
    @State private var searchText = ""
    @State private var isShowingCreate = false

    init(repository: MaintenanceCategoryRepositoryProtocol) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: MaintenanceCategoryViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    searchBar
                    content
                }
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { isShowingCreate = true } label: {
                        Image(systemName: "plus")
                            .font(.appSubheadline)
                            .foregroundStyle(Color.cjPrimary)
                    }
                }
            }
            .sheet(isPresented: $isShowingCreate) {
                CategoryFormSheet(
                    title: "New Category",
                    form: $viewModel.form,
                    isSubmitting: viewModel.isSubmitting,
                    errorMessage: viewModel.errorMessageForm
                ) {
                    await viewModel.create()
                }
                .onChange(of: viewModel.didCreateSuccessfully) { _, success in
                    guard success else { return }
                    isShowingCreate = false
                    Task { await viewModel.list(name: nil, page: 1) }
                }
            }
            .task { await viewModel.list(name: nil, page: 1) }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(Color.cjTextSecondary)
            TextField("Search categories...", text: $searchText)
                .font(.appBody).foregroundStyle(Color.cjTextPrimary)
                .onSubmit { Task { await viewModel.list(name: searchText.isEmpty ? nil : searchText, page: 1) } }
            if !searchText.isEmpty {
                Button { searchText = ""; Task { await viewModel.list(name: nil, page: 1) } } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
        .appInput()
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.categories.isEmpty {
            ProgressView().tint(Color.appShade2).frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.categories.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.categories.enumerated()), id: \.element.id) { index, cat in
                    NavigationLink {
                        MaintenanceCategoryDetailView(category: cat, repository: repository) {
                            Task { await viewModel.list(name: nil, page: 1) }
                        }
                    } label: {
                        categoryRow(cat)
                    }
                    .buttonStyle(.plain)

                    if index < viewModel.categories.count - 1 {
                        Divider().padding(.leading, 20).opacity(0.5)
                    }

                    if index == viewModel.categories.count - 1 {
                        Color.clear.frame(height: 1).onAppear {
                            guard !viewModel.isLoading, !viewModel.isLoadingNextPage else { return }
                            Task { await viewModel.loadNextPage(name: searchText.isEmpty ? nil : searchText) }
                        }
                    }
                }
                if viewModel.isLoadingNextPage {
                    ProgressView().tint(Color.appShade2).padding(20)
                }
            }
            .padding(.vertical, 8)
            .appCard()
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private func categoryRow(_ cat: MaintenanceCategoryResponse) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "tag.fill")
                .font(.appSubheadline)
                .foregroundStyle(Color.cjOnPrimary)
                .frame(width: 32, height: 32)
                .background(Color.cjPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(cat.name).font(.appSubheadline).fontWeight(.medium).foregroundStyle(Color.cjTextPrimary)
                if let desc = cat.description {
                    Text(desc).font(.appCaption).foregroundStyle(Color.cjTextSecondary).lineLimit(1)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.appCaption).foregroundStyle(Color.cjTextSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tag.slash").font(.system(size: 44)).foregroundStyle(Color.appShade1)
            Text("No categories").font(.appTitle2).foregroundStyle(Color.cjTextPrimary)
            Text("Tap + to add a category.").font(.appSubheadline).foregroundStyle(Color.cjTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Shared form sheet
struct CategoryFormSheet: View {
    let title: String
    @Binding var form: MaintenanceCategoryViewModel.CategoryForm
    let isSubmitting: Bool
    let errorMessage: String?
    let onSubmit: () async -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        AppField("Name", text: $form.name).textInputAutocapitalization(.words)
                        AppField("Description (optional)", text: $form.description).textInputAutocapitalization(.sentences)

                        if let error = errorMessage {
                            Label(error, systemImage: "xmark.circle.fill")
                                .font(.appCaption).foregroundStyle(Color.appNegative)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        AppButton(title: "Save", isLoading: isSubmitting) { await onSubmit() }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(Color.cjTextSecondary)
                }
            }
        }
    }
}
