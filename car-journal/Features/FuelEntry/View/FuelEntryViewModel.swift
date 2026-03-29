//
//  FuelEntryViewModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation
import Combine

@MainActor
class FuelEntryViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var didCreateSuccessfully = false
    
    @Published var odometerReading = ""
    @Published var readingUnit = ""
    @Published var fuelType = ""
    @Published var fuelBrand = ""
    @Published var fuelName = ""
    @Published var fuelPrice = ""
    @Published var fuelUnit = ""
    @Published var distanceTraveled = ""
    @Published var volumeFilled = ""
    @Published var notes = ""
    
    private let carID: String
    private let repository: FuelEntryRepositoryProtocol
    
    init(carID: String, repository: FuelEntryRepositoryProtocol) {
        self.carID = carID
        self.repository = repository
    }
    
    func create() async {
        let payload = FuelEntryCreateRequest(
            odometerReading: Int(odometerReading) ?? 0,
            readingUnit: readingUnit,
            carID: carID,
            fuelType: fuelType,
            fuelBrand: fuelBrand,
            fuelName: fuelName,
            fuelPrice: Double(fuelPrice) ?? 0,
            fuelUnit: fuelUnit,
            distanceTraveled: Double(distanceTraveled) ?? 0,
            volumeFilled: Double(volumeFilled) ?? 0,
            notes: notes.isEmpty ? nil : notes
        )
        print(payload)
        guard payload.validate() else {
            errorMessage = "Please fill in all the fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await repository.create(payload: payload)
            didCreateSuccessfully = true
        } catch {
            #if DEBUG
            print("error in creating fuel entry")
            #endif
            errorMessage = "Failed to create fuel entry. Please try again later"
        }
    }
}
