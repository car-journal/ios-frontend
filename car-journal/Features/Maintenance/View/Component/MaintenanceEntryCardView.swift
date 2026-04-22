//
//  MaintenanceEntryCardView.swift
//  car-journal
//

import SwiftUI

struct MaintenanceEntryCardView: View {
    let entry: MaintenanceEntryResponse

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Date column
            VStack(spacing: 2) {
                Text(entry.performedAt, format: .dateTime.day().month(.abbreviated))
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
                Text(entry.performedAt, format: .dateTime.year())
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
                Text(entry.name)
                    .font(.appSubheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.cjTextPrimary)
                    .lineLimit(1)
                Text(entry.brand)
                    .font(.appCaption)
                    .foregroundStyle(Color.cjTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            // Price
            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyFormatter.format(entry.price))
                    .font(.appSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.cjTextPrimary)
            }
        }
        .padding(.vertical, 4)
    }
}
