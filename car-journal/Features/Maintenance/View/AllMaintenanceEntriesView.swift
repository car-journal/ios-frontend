//
//  AllMaintenanceEntriesView.swift
//  car-journal
//

import SwiftUI

struct AllMaintenanceEntriesView: View {
    let carID: String
    let maintenanceRepository: MaintenanceEntryRepositoryProtocol
    let categoryRepository: MaintenanceCategoryRepositoryProtocol
    @StateObject private var viewModel: MaintenanceViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel

    @State private var searchText = ""
    @State private var sortField = "performed_at"
    @State private var sortDirection = "DESC"
    @State private var showSortPicker = false
    @State private var isShowingCreate = false

    private let sortFields = ["brand", "name", "price", "performed_at", "created_at"]
    private let sortDirections = ["ASC", "DESC"]

    private var currentSorts: String { "\(sortField):\(sortDirection)" }

    init(carID: String, maintenanceRepository: MaintenanceEntryRepositoryProtocol, categoryRepository: MaintenanceCategoryRepositoryProtocol) {
        self.carID = carID
        self.maintenanceRepository = maintenanceRepository
        self.categoryRepository = categoryRepository
        _viewModel = StateObject(wrappedValue: MaintenanceViewModel(repository: maintenanceRepository, categoryRepository: categoryRepository))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                searchAndSortBar
                content
            }
        }
        .navigationTitle("Maintenance")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MaintenanceEntryCreateView(
                        carID: carID,
                        maintenanceRepository: maintenanceRepository,
                        categoryRepository: categoryRepository
                    )
                    .environmentObject(carDetailViewModel)
                } label: {
                    Image(systemName: "plus")
                        .font(.appSubheadline)
                        .foregroundStyle(Color.cjPrimary)
                }
            }
        }
        .task {
            await viewModel.list(carID: carID, name: nil, sorts: currentSorts, page: 1)
        }
    }

    // MARK: - Search + Sort bar
    private var searchAndSortBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.cjTextSecondary)
                TextField("Search by name...", text: $searchText)
                    .font(.appBody)
                    .foregroundStyle(Color.cjTextPrimary)
                    .onSubmit { reload() }
                if !searchText.isEmpty {
                    Button { searchText = ""; reload() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.cjTextSecondary)
                    }
                }
            }
            .appInput()

            // Sort row
            HStack(spacing: 8) {
                Text("Sort:")
                    .font(.appCaption)
                    .foregroundStyle(Color.cjTextSecondary)

                Menu {
                    ForEach(sortFields, id: \.self) { field in
                        Button {
                            sortField = field
                            reload()
                        } label: {
                            HStack {
                                Text(field.replacingOccurrences(of: "_", with: " ").capitalized)
                                if sortField == field { Image(systemName: "checkmark") }
                            }
                        }
                    }
                } label: {
                    sortChip(sortField.replacingOccurrences(of: "_", with: " ").capitalized, icon: "list.bullet")
                }

                Menu {
                    ForEach(sortDirections, id: \.self) { dir in
                        Button {
                            sortDirection = dir
                            reload()
                        } label: {
                            HStack {
                                Text(dir)
                                if sortDirection == dir { Image(systemName: "checkmark") }
                            }
                        }
                    }
                } label: {
                    sortChip(sortDirection, icon: sortDirection == "ASC" ? "arrow.up" : "arrow.down")
                }

                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private func sortChip(_ label: String, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.appCaption)
            Text(label).font(.appCaption).fontWeight(.medium)
        }
        .foregroundStyle(Color.cjPrimary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.cjPrimary.opacity(0.12))
        .clipShape(Capsule())
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoadingList && viewModel.entries.isEmpty {
            ProgressView().tint(Color.appShade2).frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let err = viewModel.errorMessageList, viewModel.entries.isEmpty {
            errorState(message: err)
        } else if viewModel.entries.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.entries.enumerated()), id: \.offset) { index, entry in
                    NavigationLink {
                        MaintenanceEntryDetailView(
                            entry: entry,
                            carID: carID,
                            maintenanceRepository: maintenanceRepository,
                            categoryRepository: categoryRepository
                        )
                        .environmentObject(carDetailViewModel)
                    } label: {
                        MaintenanceEntryCardView(entry: entry)
                            .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)

                    if index < viewModel.entries.count - 1 {
                        Divider().padding(.leading, 78).opacity(0.5)
                    }

                    if index == viewModel.entries.count - 1 {
                        Color.clear.frame(height: 1).onAppear {
                            guard !viewModel.isLoadingList, !viewModel.isLoadingNextPage else { return }
                            Task { await viewModel.loadNextPage(carID: carID, name: searchText.isEmpty ? nil : searchText, sorts: currentSorts) }
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

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.slash").font(.system(size: 44)).foregroundStyle(Color.appShade1)
            Text("No maintenance entries").font(.appTitle2).foregroundStyle(Color.cjTextPrimary)
            Text("Tap + to log your first maintenance.").font(.appSubheadline).foregroundStyle(Color.cjTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle").font(.system(size: 44)).foregroundStyle(Color.appNegative)
            Text(message).font(.appSubheadline).foregroundStyle(Color.cjTextSecondary).multilineTextAlignment(.center)
            Button { reload() } label: {
                Text("Retry").font(.appSubheadline).fontWeight(.semibold).foregroundStyle(Color.cjOnPrimary)
                    .padding(.horizontal, 24).padding(.vertical, 10).background(Color.cjPrimary).clipShape(Capsule())
            }
        }
        .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func reload() {
        Task { await viewModel.list(carID: carID, name: searchText.isEmpty ? nil : searchText, sorts: currentSorts, page: 1) }
    }
}
