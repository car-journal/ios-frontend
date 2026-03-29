//
//  CarDetailViewModle.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 27/03/26.
//

import Foundation
import Combine

@MainActor
class CarDetailViewModel: ObservableObject {
    @Published var car: CarDetailResponse?
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: CarRepositoryProtocol
    
    init(repository: CarRepositoryProtocol) {
        self.repository = repository
    }
    
    func findByID(carID: String) async {
        guard !isLoading else { return }
        guard car == nil else { return } 
        error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            // try await Task.sleep(nanoseconds: 5_000_000_000)
            let response = try await repository.findByID(carID: carID)
            car = response
        } catch {
            self.error = error.localizedDescription
        }
    }
}
