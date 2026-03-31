//
//  FuelEntryDetailView.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 31/03/26.
//

import SwiftUI

struct FuelEntryDetailView: View {
    let carID: String
    let fuelEntryID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    @StateObject private var viewModel: FuelEntryViewModel
    
    init(carID: String, fuelEntryID: String, fuelRepository: FuelRepositoryProtocol, fuelEntryRepository: FuelEntryRepositoryProtocol) {
        self.carID = carID
        self.fuelEntryID = fuelEntryID
        self.fuelEntryRepository = fuelEntryRepository
        self.fuelRepository = fuelRepository
        _viewModel = StateObject(wrappedValue: FuelEntryViewModel(
            carID: carID,
            fuelRepository: fuelRepository,
            repository: fuelEntryRepository
        ))
    }
    
    var body: some View {
        ScrollView {
            if viewModel.isLoadingFindByID && viewModel.fuelEntry == nil {
                ProgressView()
                    .padding(.top, 40)
            } else if let fuelEntry = viewModel.fuelEntry {
                VStack(spacing: 20) {
                    DetailCard(title: "Fuel Information") {
                        DetailRow(
                            icon: "fuelpump.fill",
                            label: "Fuel Type",
                            value: fuelEntry.fuelType.capitalized
                        )
                        
                        DetailRow(
                            icon: "building.2.fill",
                            label: "Brand",
                            value: fuelEntry.fuelBrand.capitalized
                        )
                        
                        DetailRow(
                            icon: "tag.fill",
                            label: "Fuel Name",
                            value: fuelEntry.fuelName.capitalized
                        )
                        
                        DetailRow(
                            icon: "banknote.fill",
                            label: "Price",
                            value: "\(CurrencyFormatter.format(fuelEntry.fuelPrice)) / \(fuelEntry.fuelUnit)"
                        )
                    }
                    
                    // Trip Metrics
                    DetailCard(title: "Trip Data") {
                        DetailRow(
                            icon: "road.lanes",
                            label: "Distance Traveled",
                            value: FuelFormatter.distanceTraveledKm(fuelEntry.distanceTraveled)
                        )
                        
                        DetailRow(
                            icon: "drop.fill",
                            label: "Volume Filled",
                            value: FuelFormatter.volumeLiter(fuelEntry.volumeFilled)
                        )
                        
                        DetailRow(
                            icon: "gauge.with.dots.needle.50percent",
                            label: "Consumption",
                            value: FuelFormatter.kmPerLiter(fuelEntry.fuelConsumption)
                        )
                    }
                    
                    // Cost
                    DetailCard(title: "Cost") {
                        DetailRow(
                            icon: "creditcard.fill",
                            label: "Total Price",
                            value: CurrencyFormatter.format(fuelEntry.totalPrice)
                        )
                    }
                    
                    // Notes
                    if let notes = fuelEntry.notes, !notes.isEmpty {
                        DetailCard(title: "Notes") {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "note.text")
                                    .foregroundStyle(.secondary)
                                
                                Text(notes)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        // TODO: determine title identifier. odometer_reading or created_at etc
        .navigationTitle("Fuel Entry Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.findByID(fuelEntryID: fuelEntryID)
        }
    }
}

struct DetailCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            VStack(spacing: 12) {
                content
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundStyle(.secondary)
            Text(label)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        FuelEntryDetailView(carID: "", fuelEntryID: "", fuelRepository: MockFuelRepository(), fuelEntryRepository: MockFuelEntryRepository())
    }
}
