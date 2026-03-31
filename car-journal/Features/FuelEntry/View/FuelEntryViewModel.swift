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
    @Published var fuelEntry: FuelEntryResponse?
    @Published var fuelEntriesByCarID: [FuelEntryResponse] = []
    @Published var fuels: [FuelListResponse] = []
    @Published var fuelNames: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didCreateSuccessfully = false
    
    @Published var isLoadingFuelEntriesByCarID = false
    @Published var errorMessageFuelEntriesByCarID: String?
    
    @Published var isLoadingFuelList = false
    @Published var errorMessageFuelList: String?
    
    @Published var isLoadingFindByID = false
    @Published var errorMessageFindByID: String?
    
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
    
    // TODO: remove carID from init, set as Published var instead
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    private let repository: FuelEntryRepositoryProtocol
    var currentPage = 1
    var hasNextPage = true
    
    var currentPageFuelEntriesByID = 1
    var hasNextPageFuelEntriesByID = true
    
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
            let response = try await repository.create(payload: payload)
            didCreateSuccessfully = response.success
        } catch {
            #if DEBUG
            print("error in creating fuel entry", error)
            #endif
            errorMessage = "Failed to create fuel entry. Please try again later"
        }
    }
    
    func listFuel(name: String, page: Int?, limit: Int = 10) async {
        fuels = []
        fuelNames = []
        isLoadingFuelList = true
        errorMessageFuelList = nil
        defer { isLoadingFuelList = false }
        
        let pageToLoad = page ?? currentPage
        
        do {
            let response = try await fuelRepository.list(name: name, page: pageToLoad, limit: limit)
            fuels = response.data
            for fuel in response.data {
                fuelNames.append(fuel.name)
            }
        } catch {
            self.errorMessageFuelList = error.localizedDescription
        }
    }
    
    func listByCarID(carID: String, page: Int?, limit: Int = 10) async {
        fuelEntriesByCarID = []
        isLoadingFuelEntriesByCarID = true
        errorMessageFuelEntriesByCarID = nil
        defer { isLoadingFuelEntriesByCarID = false }
        
        let pageToLoad = page ?? currentPageFuelEntriesByID
        
        do {
            let response = try await repository.listByCarID(carID: carID, page: pageToLoad, limit: limit)
            fuelEntriesByCarID = response.data
        } catch {
            self.errorMessageFuelEntriesByCarID = error.localizedDescription
        }
    }
    
    func findByID(fuelEntryID: String) async {
        fuelEntry = nil
        isLoadingFindByID = true
        errorMessageFindByID = nil
        defer { isLoadingFindByID = false }
        
        do {
            let response = try await repository.findByID(fuelEntryID: fuelEntryID)
            fuelEntry = response
        } catch {
            self.errorMessageFindByID = error.localizedDescription
        }
    }
}
