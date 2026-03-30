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
    private var loadTask: Task<Void, Never>?
    
    init(repository: CarRepositoryProtocol) {
        self.repository = repository
    }
    
    func initialLoad(carID: String) async {
        guard car == nil else { return }
        await startLoad(carID: carID)
    }

    func refresh(carID: String) async {
        await startLoad(carID: carID, force: true)
    }
    
    private func startLoad(carID: String, force: Bool = false) async {
        if isLoading && !force { return }

        loadTask?.cancel()

        loadTask = Task {
            await findByID(carID: carID)
        }

        await loadTask?.value
    }

    
    func findByID(carID: String) async {
        guard !isLoading else { return }
        error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
//          try await Task.sleep(nanoseconds: 3_000_000_000)
            let response = try await repository.findByID(carID: carID)
            if Task.isCancelled { return }
            car = response
        } catch {
            self.error = error.localizedDescription
        }
    }
}
