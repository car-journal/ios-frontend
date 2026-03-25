//
//  CarListViewModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation
import Combine

@MainActor
class CarListViewModel: ObservableObject {
    @Published var cars: [CarListResponse] = []
    @Published var isLoading = false
    @Published var error: String?

    private let repository: CarRepository
    var currentPage = 1
    var hasNextPage = true

    init(repository: CarRepository) {
        self.repository = repository
    }

    func fetchCars(page: Int? = nil) async {
        guard !isLoading && hasNextPage else { return }
        isLoading = true
        defer { isLoading = false }

        let pageToLoad = page ?? currentPage
        
        do {
            let response = try await repository.list(page: pageToLoad)
            cars.append(contentsOf: response.data)
            hasNextPage = response.meta.hasNext
            cars = response.data
        } catch {
            self.error = error.localizedDescription
        }
    }
}
