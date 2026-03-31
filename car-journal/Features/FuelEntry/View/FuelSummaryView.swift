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
            Text(Formatter.kmPerLiter(rate))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let trend, let style = trendStyle {
                HStack(spacing: 4) {
                    Image(systemName: style.icon)
                    Text(Formatter.kmPerLiter(trend))
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
    let recentFuelEntries: [FuelEntry]
    let repository: FuelEntryRepositoryProtocol
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            recentFuelLogsHeader
            
            ForEach(Array(recentFuelEntries.enumerated()), id: \.element.id) { index, entry in
                FuelRow(fuelEntry: entry)
                    .padding(.vertical, 4)

                if index < recentFuelEntries.count - 1 {
                    Divider()
                }
            }
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

private struct FuelRow: View {
    let fuelEntry: FuelEntry
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(fuelEntry.createdAt, style: .date)
                    .font(.subheadline)
                Text(Formatter.distanceTraveledKm(fuelEntry.distanceTraveled))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formatter.kmPerLiter(fuelEntry.fuelConsumption))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(Formatter.volumeLiter(fuelEntry.volumeFilled))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    FuelSummaryView(carID: "", fuelRepository: MockFuelRepository(), fuelSummary: CarDetailResponse.mockFuelSummary, repository: MockFuelEntryRepository())
}
