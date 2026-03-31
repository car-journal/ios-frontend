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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(car.brand) \(car.model)")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Label {
                    Text(FuelFormatter.kmPerLiter(car.averageFuelConsumptionRate))
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "fuelpump.fill")
                        .font(.title3)
                }
            }
            
            HStack {
                Label(String((car.manufactureYear ?? 1990)), systemImage: "calendar")
                Spacer()
                Label(car.color, systemImage: "paintpalette")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                Text("Engine")
                Spacer()
                Text(String(car.cylinderCapacity ?? 1990))
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("Fuel")
                Spacer()
                Text(car.fuelType)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    CarCardView(car: CarListResponse.mockCar)
}
