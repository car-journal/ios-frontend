//
//  CarDetailCardView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 27/03/26.
//

import SwiftUI

struct CarDetailCardView: View {
    let car: CarDetailResponse
    @State private var page = 0
    
    var body: some View {
        VStack(spacing: 1) {
            TabView(selection: $page) {
                firstCard.tag(0).padding()
                secondCard.tag(1).padding()
            }
            .frame(height: 220)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 8) {
                ForEach(0..<2) { index in
                    Circle()
                        .fill(page == index ? Color.cyan : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: page)
                }
            }
        }
    }
}

private extension CarDetailCardView {
    var firstCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            infoRow("Brand", car.brand)
            infoRow("Model", car.model)
            infoRow("Year", "\(car.manufactureYear)")
            infoRow("Color", car.color)
            infoRow("Fuel Type", car.fuelType)
        }
        .cardStyle()
    }
}

private extension CarDetailCardView {
    var secondCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            infoRow("Cylinder", "\(car.cylinderCapacity) cc")
            infoRow("VIN", car.vehicleIdentityNumber ?? "-")
            infoRow("Engine No.", car.engineNumber ?? "-")
            infoRow("Registration Year", car.registrationYear ?? "-")
            infoRow("Ownership Doc", car.vehicleOwnershipDocumentNumber ?? "-")
        }
        .cardStyle()
    }
}

private extension CarDetailCardView {
    func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
        
        Spacer()
        
        Text(value)
            .fontWeight(.medium)
        }
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
    }
}

#Preview {
    CarDetailCardView(car: CarDetailResponse.mockCar)
}
