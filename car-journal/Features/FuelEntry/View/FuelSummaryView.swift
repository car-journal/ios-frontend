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
            Text("Fuel Summary")
                .font(.headline)
            
            AverageFuelCard(rate: fuelSummary.averageFuelConsumptionRate, trend: fuelSummary.fuelConsumptionRateTrend)
            
            FuelEntrySummary(carID: carID, fuelRepository: fuelRepository, recentFuelEntries: fuelSummary.recentFuelEntries, repository: repository)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct AverageFuelCard: View {
    let rate: Double
    let trend: Double?
    
    private struct TrendStyle {
        let icon: String
        let color: Color
    }
    
    private var trendStyle: TrendStyle? {
        guard let trend else { return nil }
        
        if trend > 0 { return TrendStyle(icon: "arrow.up", color: .green )}
        if trend < 0 { return TrendStyle(icon: "arrow.down", color: .red )}
        
        return TrendStyle(icon: "minus", color: .secondary)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(FuelFormatter.kmPerLiter(rate))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let trend, let style = trendStyle {
                HStack(spacing: 4) {
                    Image(systemName: style.icon)
                    Text(FuelFormatter.kmPerLiter(trend))
                }
                .font(.caption)
                .foregroundStyle(style.color)
            }
            
            Text("Average Consumption")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct FuelEntrySummary: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let recentFuelEntries: [FuelEntryResponse]
    let repository: FuelEntryRepositoryProtocol
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            recentFuelLogsHeader
            
            FuelEntryListComponentView(
                fuelEntries: recentFuelEntries,
                fuelRepository: fuelRepository,
                fuelEntryRepository: repository
            )
        }
        .frame(maxWidth: .infinity,)
    }
}

private extension FuelEntrySummary {
    var recentFuelLogsHeader: some View {
        HStack {
            Text("Recent Fuel Logs")
                .font(.subheadline)
                .fontWeight(.semibold)

            Spacer()

            NavigationLink {
                FuelEntryCreateView(carID: carID, fuelRepository: fuelRepository, repository: repository)
                    .environmentObject(carDetailViewModel)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.headline)
                    .padding(8)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(Circle())
            }
            
        }
    }
}


#Preview {
    FuelSummaryView(carID: "", fuelRepository: MockFuelRepository(), fuelSummary: CarDetailResponse.mockFuelSummary, repository: MockFuelEntryRepository())
}
