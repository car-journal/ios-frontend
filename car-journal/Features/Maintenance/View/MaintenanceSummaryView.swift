//
//  MaintenanceSummaryView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceSummaryView: View {
    let carID: String
    let maintenanceSummary: MaintenanceSummary
    let maintenanceRepository: MaintenanceEntryRepositoryProtocol
    let categoryRepository: MaintenanceCategoryRepositoryProtocol
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.appSubheadline)
                    .foregroundStyle(Color.appShade2)
                Text("Maintenance Summary")
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
            }

            // Total cost card
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Maintenance Cost")
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                    Text(CurrencyFormatter.format(maintenanceSummary.totalMaintenanceCost))
                        .font(.appLargeTitle)
                        .foregroundStyle(Color.cjTextPrimary)
                }
                Spacer()
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color.appShade1.opacity(0.15), Color.appShade2.opacity(0.10)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            // Recent entries
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recent Maintenance")
                        .font(.appSubheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cjTextPrimary)

                    Spacer()

                    NavigationLink {
                        AllMaintenanceEntriesView(
                            carID: carID,
                            maintenanceRepository: maintenanceRepository,
                            categoryRepository: categoryRepository
                        )
                        .environmentObject(carDetailViewModel)
                    } label: {
                        Text("See All")
                            .font(.appCaption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.appShade2)
                    }

                    NavigationLink {
                        MaintenanceEntryCreateView(
                            carID: carID,
                            maintenanceRepository: maintenanceRepository,
                            categoryRepository: categoryRepository
                        )
                        .environmentObject(carDetailViewModel)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.appHeadline)
                            .foregroundStyle(Color.appShade2)
                    }
                }

                if maintenanceSummary.recentMaintenanceEntries.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "minus.plus.batteryblock.slash")
                                .font(.title2)
                                .foregroundStyle(Color.cjTextSecondary)
                            Text("No maintenance entries yet")
                                .font(.appSubheadline)
                                .foregroundStyle(Color.cjTextSecondary)
                        }
                        .padding(.vertical, 20)
                        Spacer()
                    }
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(maintenanceSummary.recentMaintenanceEntries.enumerated()), id: \.element.id) { index, entry in
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
                            }
                            .buttonStyle(.plain)

                            if index < maintenanceSummary.recentMaintenanceEntries.count - 1 {
                                Divider()
                                    .padding(.leading, 62)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .appCard()
    }
}

#Preview {
    ZStack {
        Color.cjBackground.ignoresSafeArea()
        MaintenanceSummaryView(
            carID: "",
            maintenanceSummary: CarDetailResponse.mockMaintenanceSummary,
            maintenanceRepository: MockMaintenanceEntryRepository(),
            categoryRepository: MockMaintenanceCategoryRepository()
        )
        .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
        .padding()
    }
}
