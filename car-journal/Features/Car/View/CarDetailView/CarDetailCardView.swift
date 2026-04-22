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
    @EnvironmentObject var carDetailViewModel: CarDetailViewModel

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                TabView(selection: $page) {
                    firstCard.tag(0)
                    secondCard.tag(1)
                }
                .frame(height: 240)
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Edit button
                Button {
                    carDetailViewModel.isShowingEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.cjOnPrimary)
                        .padding(8)
                        .background(Color.appShade1)
                        .clipShape(Circle())
                }
                .padding(12)
            }

            // Page indicator
            HStack(spacing: 6) {
                ForEach(0..<2) { index in
                    Capsule()
                        .fill(page == index ? Color.appShade2 : Color.cjTextSecondary.opacity(0.3))
                        .frame(width: page == index ? 20 : 8, height: 6)
                        .animation(.spring(response: 0.3), value: page)
                }
            }
        }
        .sheet(isPresented: $carDetailViewModel.isShowingEditSheet) {
            CarEditSheet()
                .environmentObject(carDetailViewModel)
        }
    }
}

private extension CarDetailCardView {
    var firstCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(icon: "car.fill", title: "Vehicle Info")
            VStack(spacing: 0) {
                infoRow("Brand", car.brand, icon: "building.2")
                rowDivider
                infoRow("Model", car.model, icon: "tag")
                rowDivider
                infoRow("Year", "\(car.manufactureYear)", icon: "calendar")
                rowDivider
                infoRow("Color", car.color, icon: "paintpalette")
                rowDivider
                infoRow("Fuel Type", car.fuelType, icon: "fuelpump")
            }
        }
        .appCard()
        .padding(.horizontal, 2)
    }

    var secondCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader(icon: "doc.text.fill", title: "Documents")
            VStack(spacing: 0) {
                infoRow("Cylinder", "\(car.cylinderCapacity) cc", icon: "engine.combustion")
                rowDivider
                infoRow("VIN", car.vehicleIdentityNumber ?? "—", icon: "barcode")
                rowDivider
                infoRow("Engine No.", car.engineNumber ?? "—", icon: "gearshape")
                rowDivider
                infoRow("Reg. Year", car.registrationYear ?? "—", icon: "calendar.badge.checkmark")
                rowDivider
                infoRow("Ownership Doc", car.vehicleOwnershipDocumentNumber ?? "—", icon: "document.badge.gearshape")
            }
        }
        .appCard()
        .padding(.horizontal, 2)
    }

    func cardHeader(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.appSubheadline)
                .foregroundStyle(Color.appShade2)
            Text(title)
                .font(.appHeadline)
                .foregroundStyle(Color.cjTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    var rowDivider: some View {
        Divider()
            .padding(.horizontal, 16)
            .opacity(0.5)
    }

    func infoRow(_ label: String, _ value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.appCaption)
                .foregroundStyle(Color.appShade1)
                .frame(width: 18)

            Text(label)
                .font(.appSubheadline)
                .foregroundStyle(Color.cjTextSecondary)

            Spacer()

            Text(value)
                .font(.appSubheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.cjTextPrimary)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
    }
}

#Preview {
    ZStack {
        Color.cjBackground.ignoresSafeArea()
        CarDetailCardView(car: CarDetailResponse.mockCar)
            .environmentObject(CarDetailViewModel(repository: MockCarRepository()))
            .padding()
    }
}
