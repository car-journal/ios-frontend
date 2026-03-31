//
//  FuelEntryListView.swift
//  car-journal
//
//  Created by 2297 on 31/03/26.
//

import SwiftUI

struct FuelEntryListView: View {
    let carID: String
    let fuelEntries: [FuelEntry]
    let repository: FuelEntryRepositoryProtocol
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(fuelEntries.enumerated()), id: \.element.id) { index, entry in
                FuelRow(fuelEntry: entry)
                    .padding(.vertical, 4)

                if index < fuelEntries.count - 1 {
                    Divider()
                }
            }
        }
        .frame(maxWidth: .infinity,)
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
