//
//  CarCardView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import SwiftUI

struct CarCardView: View {
    let car: CarListResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top accent bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.appShade1, Color.appShade2],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .clipShape(
                    .rect(topLeadingRadius: 16, topTrailingRadius: 16)
                )

            VStack(alignment: .leading, spacing: 12) {
                // Title row
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(car.brand) \(car.model)")
                            .font(.appTitle2)
                            .foregroundStyle(Color.cjTextPrimary)

                        HStack(spacing: 6) {
                            if let year = car.manufactureYear {
                                Label(String(year), systemImage: "calendar")
                            }
                            Label(car.color, systemImage: "circle.fill")
                                .symbolRenderingMode(.palette)
                        }
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                    }

                    Spacer()

                    // Fuel efficiency badge
                    VStack(spacing: 2) {
                        Image(systemName: "fuelpump.fill")
                            .font(.caption)
                            .foregroundStyle(Color.appShade2)
                        Text(FuelFormatter.kmPerLiter(car.averageFuelConsumptionRate))
                            .font(.appCaption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.cjTextPrimary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.appShade2.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                Divider()
                    .background(Color.cjTextSecondary.opacity(0.2))

                // Stats row
                HStack(spacing: 0) {
                    statItem(label: "Engine", value: car.cylinderCapacity.map { "\($0) cc" } ?? "—")
                    Divider()
                        .frame(height: 28)
                        .background(Color.cjTextSecondary.opacity(0.2))
                    statItem(label: "Fuel", value: car.fuelType)
                }
            }
            .padding(16)
        }
        .background(Color.cjSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.appDark.opacity(0.10), radius: 10, x: 0, y: 4)
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.appCaption)
                .foregroundStyle(Color.cjTextSecondary)
            Text(value)
                .font(.appSubheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.cjTextPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.cjBackground.ignoresSafeArea()
        CarCardView(car: CarListResponse.mockCar)
            .padding()
    }
}
