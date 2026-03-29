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
    @Published var fuels: [FuelListResponse] = []
    @Published var fuelNames: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var isLoadingFuelList = false
    @Published var errorMessageFuelList: String?
    
    @Published var didCreateSuccessfully = false
    
    @Published var odometerReading = ""
    @Published var readingUnit = "km"
    @Published var fuelType = ""
    @Published var fuelBrand = ""
    @Published var fuelName = ""
    @Published var fuelPrice = ""
    @Published var fuelUnit = "liter"
    @Published var distanceTraveled = ""
    @Published var volumeFilled = ""
    @Published var notes = ""
    
    private let carID: String
    let fuelRepository: FuelRepositoryProtocol
    private let repository: FuelEntryRepositoryProtocol
    
    init(carID: String, fuelRepository: FuelRepositoryProtocol, repository: FuelEntryRepositoryProtocol) {
        self.carID = carID
        self.fuelRepository = fuelRepository
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
            print("error in creating fuel entry", error)
            #endif
            errorMessage = "Failed to create fuel entry. Please try again later"
        }
    }
    
    func listFuel(name: String) async {
        fuels = []
        fuelNames = []
        isLoadingFuelList = true
        errorMessageFuelList = nil
        defer { isLoadingFuelList = false }
        
        do {
            let response = try await fuelRepository.list(name: name)
            fuels = response.data
            for fuel in response.data {
                fuelNames.append(fuel.name)
            }
        } catch {
            self.errorMessageFuelList = error.localizedDescription
        }
    }
}
