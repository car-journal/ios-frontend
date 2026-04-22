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
    @Published var editForm = CarEditForm()
    @Published var isUpdating = false
    @Published var didUpdateSuccessfully = false
    @Published var errorMessageUpdate: String?
    @Published var isShowingEditSheet = false
    
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
        error = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
//          try await Task.sleep(nanoseconds: 3_000_000_000)
            let response = try await repository.findByID(carID: carID)
            if Task.isCancelled { return }
            car = response
            editForm = CarEditForm(from: response)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func update(carID: String) async {
        if let validationError = editForm.validate() {
            errorMessageUpdate = validationError
            return
        }
        
        let payload = editForm.toUpdateRequest()
        isUpdating = true
        errorMessageUpdate = nil
        defer { isUpdating = false }
        
        do {
            let response = try await repository.update(carID: carID, payload: payload)
            if response.success {
                didUpdateSuccessfully = true
                await refresh(carID: carID)
            }
        } catch {
            #if DEBUG
            print("error updating car", error)
            #endif
            errorMessageUpdate = "Failed to update car. Please try again later"
        }
    }
}
