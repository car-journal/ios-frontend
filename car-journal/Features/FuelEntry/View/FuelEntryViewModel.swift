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
    
    @Published var form = FuelEntryForm()
    @Published var editForm = FuelEntryEditForm()
    @Published var isUpdating = false
    @Published var didUpdateSuccessfully = false
    @Published var errorMessageUpdate: String?
    @Published var isLoadingNextPage = false

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
        if let error = form.validate() {
            errorMessage = error
            return
        }
        
        let payload = form.toRequest(carID: carID)
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
        currentPageFuelEntriesByID = page ?? 1
        hasNextPageFuelEntriesByID = true
        isLoadingFuelEntriesByCarID = true
        errorMessageFuelEntriesByCarID = nil
        defer { isLoadingFuelEntriesByCarID = false }
        
        do {
            let response = try await repository.listByCarID(carID: carID, page: currentPageFuelEntriesByID, limit: limit)
            fuelEntriesByCarID = response.data
            hasNextPageFuelEntriesByID = response.meta.hasNext
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
            editForm = FuelEntryEditForm(from: response)
        } catch {
            self.errorMessageFindByID = error.localizedDescription
        }
    }
    
    func update(fuelEntryID: String) async {
        if let error = editForm.validate() {
            errorMessageUpdate = error
            return
        }
        
        let payload = editForm.toUpdateRequest(carID: carID)
        isUpdating = true
        errorMessageUpdate = nil
        defer { isUpdating = false }
        
        do {
            let response = try await repository.update(fuelEntryID: fuelEntryID, payload: payload)
            didUpdateSuccessfully = response.success
        } catch {
            #if DEBUG
            print("error updating fuel entry", error)
            #endif
            errorMessageUpdate = "Failed to update fuel entry. Please try again later"
        }
    }
    
    func loadNextPage(carID: String, limit: Int = 10) async {
        guard hasNextPageFuelEntriesByID && !isLoadingNextPage else { return }
        currentPageFuelEntriesByID += 1
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        
        do {
            let response = try await repository.listByCarID(carID: carID, page: currentPageFuelEntriesByID, limit: limit)
            fuelEntriesByCarID.append(contentsOf: response.data)
            hasNextPageFuelEntriesByID = response.meta.hasNext
        } catch {
            currentPageFuelEntriesByID -= 1
            self.errorMessageFuelEntriesByCarID = error.localizedDescription
        }
    }
}
