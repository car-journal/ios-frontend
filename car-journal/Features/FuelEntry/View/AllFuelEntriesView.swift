//
//  AllFuelEntriesView.swift
//  car-journal
//
//  Created by Kiro on 21/04/26.
//

import SwiftUI

struct AllFuelEntriesView: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    @StateObject private var viewModel: FuelEntryViewModel
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel

    init(carID: String, fuelRepository: FuelRepositoryProtocol, fuelEntryRepository: FuelEntryRepositoryProtocol) {
        self.carID = carID
        self.fuelRepository = fuelRepository
        self.fuelEntryRepository = fuelEntryRepository
        _viewModel = StateObject(wrappedValue: FuelEntryViewModel(
            carID: carID,
            fuelRepository: fuelRepository,
            repository: fuelEntryRepository
        ))
    }

    var body: some View {
        ZStack {
            Color.cjBackground.ignoresSafeArea()
            content
        }
        .navigationTitle("Fuel Entries")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.cjBackground, for: .navigationBar)
        .task {
            await viewModel.listByCarID(carID: carID, page: 1)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoadingFuelEntriesByCarID && viewModel.fuelEntriesByCarID.isEmpty {
            ProgressView()
                .tint(Color.appShade2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessageFuelEntriesByCarID,
                  viewModel.fuelEntriesByCarID.isEmpty {
            errorState(message: errorMessage)
        } else if viewModel.fuelEntriesByCarID.isEmpty {
            emptyState
        } else {
            listContent
        }
    }

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.fuelEntriesByCarID.enumerated()), id: \.offset) { index, entry in
                    NavigationLink {
                        FuelEntryDetailView(
                            carID: carID,
                            fuelEntryID: entry.id.uuidString,
                            fuelRepository: fuelRepository,
                            fuelEntryRepository: fuelEntryRepository
                        )
                        .environmentObject(carDetailViewModel)
                    } label: {
                        FuelEntryCardComponentView(fuelEntry: entry)
                            .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)

                    if index < viewModel.fuelEntriesByCarID.count - 1 {
                        Divider()
                            .padding(.leading, 78)
                            .opacity(0.5)
                    }

                    // Pagination trigger on last item
                    if index == viewModel.fuelEntriesByCarID.count - 1 {
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                guard !viewModel.isLoadingFuelEntriesByCarID,
                                      !viewModel.isLoadingNextPage else { return }
                                Task {
                                    await viewModel.loadNextPage(carID: carID)
                                }
                            }
                    }
                }

                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .tint(Color.appShade2)
                        .padding(20)
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
            Image(systemName: "fuelpump.slash")
                .font(.system(size: 44))
                .foregroundStyle(Color.appShade1)
            Text("No fuel entries yet")
                .font(.appTitle2)
                .foregroundStyle(Color.cjTextPrimary)
            Text("Tap + to log your first fill-up.")
                .font(.appSubheadline)
                .foregroundStyle(Color.cjTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(Color.appNegative)
            Text(message)
                .font(.appSubheadline)
                .foregroundStyle(Color.cjTextSecondary)
                .multilineTextAlignment(.center)
            Button {
                Task { await viewModel.listByCarID(carID: carID, page: 1) }
            } label: {
                Text("Retry")
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.cjOnPrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.cjPrimary)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        AllFuelEntriesView(
            carID: "",
            fuelRepository: MockFuelRepository(),
            fuelEntryRepository: MockFuelEntryRepository()
        )
        .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
    }
}
