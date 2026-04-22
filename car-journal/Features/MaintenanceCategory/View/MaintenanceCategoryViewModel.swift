//
//  MaintenanceCategoryViewModel.swift
//  car-journal
//

import Foundation
import Combine

@MainActor
class MaintenanceCategoryViewModel: ObservableObject {
    @Published var categories: [MaintenanceCategoryResponse] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String?
    var currentPage = 1
    var hasNextPage = true

    @Published var form = CategoryForm()
    @Published var isSubmitting = false
    @Published var didCreateSuccessfully = false
    @Published var didUpdateSuccessfully = false
    @Published var didDeleteSuccessfully = false
    @Published var errorMessageForm: String?

    private let repository: MaintenanceCategoryRepositoryProtocol

    init(repository: MaintenanceCategoryRepositoryProtocol) {
        self.repository = repository
    }

    struct CategoryForm {
        var name: String = ""
        var description: String = ""
    }

    func list(name: String?, page: Int, limit: Int = 20) async {
        guard !isLoading else { return }
        if page == 1 { categories = []; hasNextPage = true }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await repository.list(name: name, sorts: "name:asc", page: page, limit: limit)
            if page == 1 { categories = response.data } else { categories.append(contentsOf: response.data) }
            hasNextPage = response.meta.hasNext
            currentPage = page
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadNextPage(name: String?) async {
        guard hasNextPage && !isLoadingNextPage && !isLoading else { return }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        let next = currentPage + 1
        do {
            let response = try await repository.list(name: name, sorts: "name:asc", page: next, limit: 20)
            categories.append(contentsOf: response.data)
            hasNextPage = response.meta.hasNext
            currentPage = next
        } catch { errorMessage = error.localizedDescription }
    }

    func create() async {
        guard !form.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessageForm = "Name is required"; return
        }
        isSubmitting = true; errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let payload = MaintenanceCategoryCreateRequest(name: form.name, description: form.description.isEmpty ? nil : form.description)
            let response = try await repository.create(payload: payload)
            didCreateSuccessfully = response.success
        } catch { errorMessageForm = "Failed to create category." }
    }

    func update(categoryID: String) async {
        guard !form.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessageForm = "Name is required"; return
        }
        isSubmitting = true; errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let payload = MaintenanceCategoryUpdateRequest(name: form.name, description: form.description.isEmpty ? nil : form.description)
            let response = try await repository.update(categoryID: categoryID, payload: payload)
            didUpdateSuccessfully = response.success
        } catch { errorMessageForm = "Failed to update category." }
    }

    func delete(categoryID: String) async {
        isSubmitting = true; errorMessageForm = nil
        defer { isSubmitting = false }
        do {
            let response = try await repository.delete(categoryID: categoryID)
            didDeleteSuccessfully = response.success
        } catch { errorMessageForm = "Failed to delete category." }
    }
}
