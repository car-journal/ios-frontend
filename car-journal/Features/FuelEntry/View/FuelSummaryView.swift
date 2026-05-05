//
//  FuelSummaryView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 28/03/26.
//

import SwiftUI

struct FuelSummaryView: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelSummary: FuelSummary
    let repository: FuelEntryRepositoryProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack(spacing: 8) {
                Image(systemName: "fuelpump.fill")
                    .font(.appSubheadline)
                    .foregroundStyle(Color.appShade2)
                Text("Fuel Summary")
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
            }

            AverageFuelCard(
                rate: fuelSummary.averageFuelConsumptionRate,
                increase: fuelSummary.fuelConsumptionRateIncrease,
                trend: fuelSummary.fuelConsumptionRateTrend,
                totalCost: fuelSummary.totalFuelCost
            )

            FuelEntrySummary(
                carID: carID,
                fuelRepository: fuelRepository,
                recentFuelEntries: fuelSummary.recentFuelEntries,
                repository: repository
            )
        }
        .padding(16)
        .appCard()
    }
}

// MARK: - Average fuel efficiency card
private struct AverageFuelCard: View {
    let rate: Double
    let increase: Double?   // Km/L delta
    let trend: Double?      // percentage delta
    let totalCost: Decimal

    private struct TrendStyle {
        let icon: String
        let color: Color
    }

    // Direction is determined by trend (percentage); increase follows the same sign
    private var trendStyle: TrendStyle? {
        guard let trend else { return nil }
        if trend > 0 { return TrendStyle(icon: "arrow.up.right", color: .appPositive) }
        if trend < 0 { return TrendStyle(icon: "arrow.down.right", color: .appNegative) }
        return TrendStyle(icon: "minus", color: Color.cjTextSecondary)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 0) {
                // Main stat
                VStack(alignment: .leading, spacing: 4) {
                    Text("Avg. Consumption")
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                    Text(FuelFormatter.kmPerLiter(rate))
                        .font(.appLargeTitle)
                        .foregroundStyle(Color.cjTextPrimary)
                }

                Spacer()

                // Trend badge — one arrow, two lines of data
                if let style = trendStyle {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: style.icon)
                            .font(.appHeadline)
                            .foregroundStyle(style.color)

                        VStack(alignment: .leading, spacing: 2) {
                            // Km/L delta
                            if let increase {
                                Text(FuelFormatter.kmPerLiter(abs(increase)))
                                    .font(.appSubheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(style.color)
                            }
                            // Percentage delta
                            if let trend {
                                Text(String(format: "%.1f%%", abs(trend)))
                                    .font(.appCaption)
                                    .foregroundStyle(style.color.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(style.color.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }

            Divider().opacity(0.4)

            // Total cost row
            HStack {
                Label("Total Fuel Cost", systemImage: "creditcard.fill")
                    .font(.appCaption)
                    .foregroundStyle(Color.cjTextSecondary)
                Spacer()
                Text(CurrencyFormatter.format(totalCost))
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.cjTextPrimary)
            }
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
    }
}

// MARK: - Recent entries list
private struct FuelEntrySummary: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let recentFuelEntries: [FuelEntryResponse]
    let repository: FuelEntryRepositoryProtocol
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            recentFuelLogsHeader

            if recentFuelEntries.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "fuelpump.slash")
                            .font(.title2)
                            .foregroundStyle(Color.cjTextSecondary)
                        Text("No fuel entries yet")
                            .font(.appSubheadline)
                            .foregroundStyle(Color.cjTextSecondary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            } else {
                FuelEntryListComponentView(
                    fuelEntries: recentFuelEntries,
                    fuelRepository: fuelRepository,
                    fuelEntryRepository: repository
                )
            }
        }
    }

    var recentFuelLogsHeader: some View {
        HStack {
            Text("Recent Fuel Logs")
                .font(.appSubheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.cjTextPrimary)

            Spacer()

            NavigationLink {
                AllFuelEntriesView(
                    carID: carID,
                    fuelRepository: fuelRepository,
                    fuelEntryRepository: repository
                )
                .environmentObject(carDetailViewModel)
            } label: {
                Text("See All")
                    .font(.appCaption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appShade2)
            }

            NavigationLink {
                FuelEntryCreateView(
                    carID: carID,
                    fuelRepository: fuelRepository,
                    repository: repository
                )
                .environmentObject(carDetailViewModel)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.appHeadline)
                    .foregroundStyle(Color.appShade2)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.cjBackground.ignoresSafeArea()
        FuelSummaryView(
            carID: "",
            fuelRepository: MockFuelRepository(),
            fuelSummary: CarDetailResponse.mockFuelSummary,
            repository: MockFuelEntryRepository()
        )
        .padding()
    }
}
