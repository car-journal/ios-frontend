//
//  MockFuelEntryViewModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation
import SwiftUI
import Combine

// Mock version for preview
final class MockFuelEntryViewModel: FuelEntryViewModel {
    init() {
        let mockFuelRepo = MockFuelRepository()
        let mockFuelEntryRepo = MockFuelEntryRepository()
        super.init(carID: "mock-car-id", fuelRepository: mockFuelRepo, repository: mockFuelEntryRepo)
    }
    
    override func listFuel(name: String, page: Int?, limit: Int) async {
        isLoadingFuelList = true
        errorMessageFuelList = nil
        defer { isLoadingFuelList = false }
        
        do {
            let response = try await fuelRepository.list(name: name, page: page ?? 1, limit: limit)
            // Use the repository data to fill fuelNames
            fuelNames = response.data.map { $0.name }
        } catch {
            errorMessageFuelList = error.localizedDescription
        }
    }
}
