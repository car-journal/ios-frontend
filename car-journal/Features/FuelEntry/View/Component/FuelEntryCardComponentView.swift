//
//  FuelEntryCardView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 31/03/26.
//

import SwiftUI

struct FuelEntryCardComponentView: View {
    let fuelEntry: FuelEntryResponse
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(fuelEntry.filledAt, style: .date)
                    .font(.subheadline)
                Text(FuelFormatter.distanceTraveledKm(fuelEntry.distanceTraveled))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(FuelFormatter.kmPerLiter(fuelEntry.fuelConsumption))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(FuelFormatter.volumeLiter(fuelEntry.volumeFilled))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
