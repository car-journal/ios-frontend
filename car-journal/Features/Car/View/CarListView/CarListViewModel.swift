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

    private let repository: CarRepositoryProtocol
    var currentPage = 1
    var hasNextPage = true

    init(repository: CarRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCars(page: Int? = nil) async {
        guard !isLoading && hasNextPage else { return }
        isLoading = true
        defer { isLoading = false }

        let pageToLoad = page ?? currentPage
        
        do {
//            try await Task.sleep(nanoseconds: 5_000_000_000)
            let response = try await repository.list(page: pageToLoad)
            if pageToLoad == 1 {
                cars = response.data
            } else {
                cars.append(contentsOf: response.data)
            }
            hasNextPage = response.meta.hasNext
            currentPage = pageToLoad
        } catch {
            self.error = error.localizedDescription
        }
    }
}
