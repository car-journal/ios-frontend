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
        HStack(alignment: .center, spacing: 12) {
            // Date column
            VStack(spacing: 2) {
                Text(fuelEntry.filledAt, format: .dateTime.day().month(.abbreviated))
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
                Text(fuelEntry.filledAt, format: .dateTime.year())
                    .font(.appCaption)
                    .foregroundStyle(Color.cjTextSecondary)
            }
            .frame(width: 44)
            .padding(.vertical, 8)
            .padding(.horizontal, 6)
            .background(Color.appShade1.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // Middle info
            VStack(alignment: .leading, spacing: 3) {
                Text(fuelEntry.fuelName.isEmpty ? "\(fuelEntry.fuelBrand) \(fuelEntry.fuelType)" : fuelEntry.fuelName)
                    .font(.appSubheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.cjTextPrimary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label(FuelFormatter.distanceTraveledKm(fuelEntry.distanceTraveled), systemImage: "road.lanes")
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                    Label(FuelFormatter.volumeLiter(fuelEntry.volumeFilled), systemImage: "drop.fill")
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                }
            }

            Spacer()

            // Efficiency
            VStack(alignment: .trailing, spacing: 2) {
                Text(FuelFormatter.kmPerLiter(fuelEntry.fuelConsumption))
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.cjTextPrimary)
            }
        }
        .padding(.vertical, 4)
    }
}
