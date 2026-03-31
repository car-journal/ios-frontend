//
//  FuelEntryListView.swift
//  car-journal
//
//  Created by 2297 on 31/03/26.
//

import SwiftUI

struct FuelEntryListComponentView: View {
    let fuelEntries: [FuelEntryResponse]
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(fuelEntries.enumerated()), id: \.element.id) { index, entry in
                NavigationLink {
                    FuelEntryDetailView(
                        carID: entry.carId.uuidString,
                        fuelEntryID: entry.id.uuidString,
                        fuelRepository: fuelRepository,
                        fuelEntryRepository: fuelEntryRepository
                    )
                } label: {
                    FuelEntryCardComponentView(fuelEntry: entry)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain) // keeps card style clean
                    
                    if index < fuelEntries.count - 1 {
                        Divider()
                }
            }
        }
        .frame(maxWidth: .infinity,)
    }
}
