//
//  MaintenanceViewModel.swift
//  car-journal
//

import Foundation
import Combine

@MainActor
class MaintenanceViewModel: ObservableObject {
    // List
    @Published var entries: [MaintenanceEntryResponse] = []
    @Published var isLoadingList = false
    @Published var isLoadingNextPage = false
    @Published var errorMessageList: String?
    var currentPage = 1
    var hasNextPage = true

    // Create / Update / Delete
    @Published var form = MaintenanceEntryForm()
    @Published var isSubmitting = false
    @Published var didCreateSuccessfully = false
    @Published var didUpdateSuccessfully = false
    @Published var didDeleteSuccessfully = false
    @Published var errorMessageForm: String?

    // Categories
    @Published var categories: [MaintenanceCategoryResponse] = []
    @Published var isLoadingCategories = false

    private let repository: MaintenanceEntryRepositoryProtocol
    private let categoryRepository: MaintenanceCategoryRepositoryProtocol

    init(repository: MaintenanceEntryRepositoryProtocol, categoryRepository: MaintenanceCategoryRepositoryProtocol) {
        self.repository = repository
        self.categoryRepository = categoryRepository
    }

    // MARK: - List
    func list(carID: String, name: String?, sorts: String?, page: Int, limit: Int = 10) async {
        guard !isLoadingList else { return }
        if page == 1 {
            entries = []
            hasNextPage = true
        }
        isLoadingList = true
        errorMessageList = nil
        defer { isLoadingList = false }

        do {
            let response = try await repository.list(carID: carID, name: name, sorts: sorts, page: page, limit: limit)
            if page == 1 {
                entries = response.data
            } else {
                entries.append(contentsOf: response.data)
            }
            hasNextPage = response.meta.hasNext
            currentPage = page
        } catch {
            errorMessageList = error.localizedDescription
        }
    }

    func loadNextPage(carID: String, name: String?, sorts: String?, limit: Int = 10) async {
        guard hasNextPage && !isLoadingNextPage && !isLoadingList else { return }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        let nextPage = currentPage + 1
        do {
            let response = try await repository.list(carID: carID, name: name, sorts: sorts, page: nextPage, limit: limit)
            entries.append(contentsOf: response.data)
            hasNextPage = response.meta.hasNext
            currentPage = nextPage
        } catch {
            errorMessageList = error.localizedDescription
        }
    }

    // MARK: - Create
    func create(carID: String) async {
        if let error = form.validate() {
            errorMessageForm = error
            return
        }
        isSubmitting = true
        errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let response = try await repository.create(carID: carID, payload: form.toCreateRequest())
            didCreateSuccessfully = response.success
        } catch {
            errorMessageForm = "Failed to create entry. Please try again."
        }
    }

    // MARK: - Update
    func update(entryID: String) async {
        if let error = form.validate() {
            errorMessageForm = error
            return
        }
        isSubmitting = true
        errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let response = try await repository.update(entryID: entryID, payload: form.toUpdateRequest())
            didUpdateSuccessfully = response.success
        } catch {
            errorMessageForm = "Failed to update entry. Please try again."
        }
    }

    // MARK: - Delete
    func delete(entryID: String) async {
        isSubmitting = true
        errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let response = try await repository.delete(entryID: entryID)
            didDeleteSuccessfully = response.success
        } catch {
            errorMessageForm = "Failed to delete entry. Please try again."
        }
    }

    // MARK: - Categories
    func loadCategories() async {
        guard categories.isEmpty else { return }
        isLoadingCategories = true
        defer { isLoadingCategories = false }
        do {
            let response = try await categoryRepository.list(name: nil, sorts: "name:asc", page: 1, limit: 100)
            categories = response.data
        } catch {
            // silently fail — categories will just be empty
        }
    }
}
