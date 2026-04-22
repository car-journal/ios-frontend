# Implementation Plan: car-journal-editable-views

## Overview

Implement editing capabilities across three areas of the Car Journal iOS app: (1) convert `FuelEntryDetailView` into an editable form backed by `PATCH /v1/internal/fuel-entries/:id`, (2) add an `AllFuelEntriesView` with pagination reachable via a "See All" button on the Car Detail page, and (3) add a `CarEditSheet` modal to `CarDetailCardView` backed by `PATCH /v1/internal/cars/:id`. All work follows the existing MVVM + protocol-based repository pattern with async/await networking.

## Tasks

- [x] 1. Add `HTTPMethod.patch` and `FuelEntryEndpoint.update` / `CarEndpoint.update` cases
  - [x] 1.1 Add `case patch = "PATCH"` to the `HTTPMethod` enum in `Endpoint.swift`
    - The `CarEndpoint.update` case requires `.patch`; no other existing cases are affected
    - _Requirements: 1.7, 3.6_
  - [x] 1.2 Add `case update(fuelEntryID: String, payload: FuelEntryUpdateRequest, token: String)` to `FuelEntryEndpoint`
    - Path: `PATCH /v1/internal/fuel-entries/:fuel_entry_id`
    - Method: `.patch`; headers: Bearer token; body: `payload`; queryItems: nil
    - _Requirements: 1.7_
  - [x] 1.3 Add `case update(carID: String, payload: CarUpdateRequest, token: String)` to `CarEndpoint`
    - Path: `PATCH /v1/internal/cars/:car_id`
    - Method: `.patch`; headers: Bearer token; body: `payload`; queryItems: nil
    - Also add `listOfFuelEntries` query items (`page`, `limit`) which are currently nil — fix while touching the file
    - _Requirements: 3.6, 2.3_

- [x] 2. Extend repository protocols and implementations with `update` methods
  - [x] 2.1 Add `func update(fuelEntryID: String, payload: FuelEntryUpdateRequest) async throws -> MutationResponse` to `FuelEntryRepositoryProtocol`
    - _Requirements: 1.7_
  - [x] 2.2 Implement `update` in `FuelEntryRepositoryImpl`
    - Call `authManager.requireAccessToken()`, build `FuelEntryEndpoint.update`, call `apiClient.send`
    - _Requirements: 1.7_
  - [x] 2.3 Add stub `update` to `MockFuelEntryRepository` returning `MutationResponse(success: true)`
    - Located at `Features/FuelEntry/View/MockFuelEntryRepository.swift`
    - _Requirements: 1.7_
  - [x] 2.4 Add `func update(carID: String, payload: CarUpdateRequest) async throws -> MutationResponse` to `CarRepositoryProtocol`
    - _Requirements: 3.10_
  - [x] 2.5 Implement `update` in `CarRepositoryImpl`
    - Call `authManager.requireAccessToken()`, build `CarEndpoint.update`, call `apiClient.send`
    - _Requirements: 3.6_
  - [x] 2.6 Add stub `update` to `MockCarRepository` returning `MutationResponse(success: true)`
    - Located at `Features/Car/Repository/MockCarRepository.swift`
    - _Requirements: 3.10_

- [x] 3. Checkpoint — Ensure the project compiles with no errors before proceeding to model layer
  - Ensure all tests pass, ask the user if questions arise.

- [x] 4. Implement `FuelEntryEditForm` model
  - [x] 4.1 Create `Features/FuelEntry/Model/FuelEntryEditForm.swift`
    - Mirror `FuelEntryForm` fields but all `String` (plus `filledAt: Date`)
    - Add `init(from response: FuelEntryResponse)` mapping each field; `odometerReading` defaults to `""` (API gap noted in design)
    - Add `validate() -> String?` reusing the same rules as `FuelEntryForm.validate()`
    - Add `toUpdateRequest(carID: String, fuelEntryID: String) -> FuelEntryUpdateRequest`; format `filledAt` as ISO 8601 string using `ISO8601DateFormatter`
    - _Requirements: 1.1, 1.2, 1.5, 1.7_
  - [ ]* 4.2 Write property test for `FuelEntryEditForm` pre-population round-trip (Property 1)
    - **Property 1: FuelEntryEditForm pre-population round-trip**
    - Generate arbitrary `FuelEntryResponse` values via SwiftCheck `Arbitrary`; verify `FuelEntryEditForm(from:)` maps `fuelType`, `fuelBrand`, `fuelName`, `fuelUnit`, `distanceTraveled`, `volumeFilled`, `filledAt`, and `notes` correctly
    - Tag: `// Feature: car-journal-editable-views, Property 1: FuelEntryEditForm pre-population round-trip`
    - **Validates: Requirements 1.1**
  - [ ]* 4.3 Write property test for `FuelEntryEditForm` validation rejects invalid inputs (Property 3)
    - **Property 3: FuelEntryEditForm validation rejects invalid inputs**
    - Generate arbitrary `FuelEntryEditForm` values with at least one invalid field; verify `validate()` returns non-nil
    - Tag: `// Feature: car-journal-editable-views, Property 3: FuelEntryEditForm validation rejects invalid inputs`
    - **Validates: Requirements 1.5**
  - [ ]* 4.4 Write property test for `FuelEntryEditForm.toUpdateRequest` field mapping (Property 4)
    - **Property 4: FuelEntryEditForm toUpdateRequest field mapping**
    - Generate arbitrary valid `FuelEntryEditForm` values; verify `toUpdateRequest(carID:fuelEntryID:)` produces a `FuelEntryUpdateRequest` with matching parsed field values
    - Tag: `// Feature: car-journal-editable-views, Property 4: FuelEntryEditForm toUpdateRequest field mapping`
    - **Validates: Requirements 1.7**

- [x] 5. Implement `CarEditForm` model
  - [x] 5.1 Create `Features/Car/Model/CarEditForm.swift`
    - All fields `String`; add `init(from response: CarDetailResponse)` mapping each field (optional fields default to `""`)
    - Add `validate() -> String?`: brand, model, color, fuelType non-empty; manufactureYear and cylinderCapacity parse as positive integers
    - Add `toUpdateRequest() -> CarUpdateRequest`: parse Int fields; map empty strings to `nil` for optional fields
    - _Requirements: 3.2, 3.3, 3.4, 3.6_
  - [ ]* 5.2 Write property test for `CarEditForm` pre-population round-trip (Property 6)
    - **Property 6: CarEditForm pre-population round-trip**
    - Generate arbitrary `CarDetailResponse` values; verify `CarEditForm(from:)` maps all fields correctly, with nil optional fields becoming `""`
    - Tag: `// Feature: car-journal-editable-views, Property 6: CarEditForm pre-population round-trip`
    - **Validates: Requirements 3.3**
  - [ ]* 5.3 Write property test for `CarEditForm` validation rejects invalid inputs (Property 7)
    - **Property 7: CarEditForm validation rejects invalid inputs**
    - Generate arbitrary `CarEditForm` values with at least one invalid field; verify `validate()` returns non-nil
    - Tag: `// Feature: car-journal-editable-views, Property 7: CarEditForm validation rejects invalid inputs`
    - **Validates: Requirements 3.4**
  - [ ]* 5.4 Write property test for `CarEditForm.toUpdateRequest` field mapping (Property 8)
    - **Property 8: CarEditForm toUpdateRequest field mapping**
    - Generate arbitrary valid `CarEditForm` values; verify `toUpdateRequest()` produces a `CarUpdateRequest` with matching parsed field values
    - Tag: `// Feature: car-journal-editable-views, Property 8: CarEditForm toUpdateRequest field mapping`
    - **Validates: Requirements 3.6**

- [x] 6. Extend `FuelEntryViewModel` with edit and pagination state
  - [x] 6.1 Add edit-related published properties and `update(fuelEntryID:)` method to `FuelEntryViewModel`
    - Add `@Published var editForm = FuelEntryEditForm()`
    - Add `@Published var isUpdating = false`, `@Published var didUpdateSuccessfully = false`, `@Published var errorMessageUpdate: String?`
    - Add `func update(fuelEntryID: String) async`: validate `editForm`, call `repository.update`, set `didUpdateSuccessfully` or `errorMessageUpdate`; clear `errorMessageUpdate` at start
    - After `findByID` succeeds, populate `editForm` from the fetched `FuelEntryResponse`
    - _Requirements: 1.5, 1.6, 1.7, 1.8, 1.9, 1.10_
  - [x] 6.2 Add pagination support to `listByCarID` and add `loadNextPage(carID:)` method
    - Add `@Published var isLoadingNextPage = false`
    - Modify `listByCarID` to **append** results when `page > 1` instead of replacing; update `currentPageFuelEntriesByID` and `hasNextPageFuelEntriesByID` from `PaginationMeta`
    - Add `func loadNextPage(carID: String) async` that increments `currentPageFuelEntriesByID` and calls `listByCarID`
    - _Requirements: 2.8, 2.9_
  - [ ]* 6.3 Write property test for pagination append preserves order (Property 5)
    - **Property 5: Pagination append preserves order**
    - Generate two arbitrary non-overlapping arrays of `FuelEntryResponse`; simulate loading page 1 then page 2 via the view model; verify `fuelEntriesByCarID` equals page1 + page2 with no items dropped or reordered
    - Tag: `// Feature: car-journal-editable-views, Property 5: Pagination append preserves order`
    - **Validates: Requirements 2.8**

- [x] 7. Extend `CarDetailViewModel` with edit state and `update(carID:)` method
  - [x] 7.1 Add edit-related published properties and `update(carID:)` method to `CarDetailViewModel`
    - Add `@Published var editForm = CarEditForm()`
    - Add `@Published var isUpdating = false`, `@Published var didUpdateSuccessfully = false`, `@Published var errorMessageUpdate: String?`, `@Published var isShowingEditSheet = false`
    - Add `func update(carID: String) async`: validate `editForm`, call `repository.update`, set `didUpdateSuccessfully` or `errorMessageUpdate`; clear `errorMessageUpdate` at start
    - After `findByID` succeeds, populate `editForm` from the fetched `CarDetailResponse`
    - _Requirements: 3.4, 3.5, 3.6, 3.7, 3.8, 3.9_

- [x] 8. Checkpoint — Ensure the project compiles and all existing tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 9. Convert `FuelEntryDetailView` to an editable form
  - [x] 9.1 Rewrite `FuelEntryDetailView` body to render editable form fields bound to `viewModel.editForm`
    - Replace the read-only `DetailCard` / `DetailRow` layout with `TextField` fields matching the `FuelEntryCreateView` form pattern (same fields, same styling)
    - Include `FuelNameDropdown` for the fuel name field, passing `viewModel` so it auto-populates `fuelType`, `fuelBrand`, and `fuelPrice` on selection
    - Add a "Save" `AppButton` that calls `viewModel.update(fuelEntryID: fuelEntryID)`; set `isLoading: viewModel.isUpdating` and disable when `viewModel.isUpdating`
    - Display `viewModel.errorMessageUpdate` as a red caption when non-nil
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.6, 1.10_
  - [x] 9.2 Wire `didUpdateSuccessfully` to dismiss and refresh `CarDetailViewModel`
    - Add `.onChange(of: viewModel.didUpdateSuccessfully)` — when true, call `carDetailViewModel.refresh(carID: viewModel.carID)` and `dismiss()`
    - Inject `@EnvironmentObject var carDetailViewModel: CarDetailViewModel` (same pattern as `FuelEntryCreateView`)
    - _Requirements: 1.8_
  - [ ]* 9.3 Write property test for `FuelNameDropdown` selection auto-populates form fields (Property 2)
    - **Property 2: FuelNameDropdown selection auto-populates form fields**
    - Generate arbitrary `FuelListResponse` values; simulate the selection tap gesture logic (set `fuelType`, `fuelBrand`, `fuelPrice` on `viewModel.editForm`); verify each field matches the selected fuel's values
    - Tag: `// Feature: car-journal-editable-views, Property 2: FuelNameDropdown selection auto-populates form fields`
    - **Validates: Requirements 1.4**

- [x] 10. Build `AllFuelEntriesView` with pagination
  - [x] 10.1 Create `Features/FuelEntry/View/AllFuelEntriesView.swift`
    - `@StateObject private var viewModel: FuelEntryViewModel` initialized with `carID`, `fuelRepository`, `fuelEntryRepository`
    - On `.task`, call `viewModel.listByCarID(carID: carID, page: 1)`
    - Render a `List` (or `LazyVStack` inside `ScrollView`) of `FuelEntryCardComponentView` rows, each wrapped in a `NavigationLink` to `FuelEntryDetailView` with `.environmentObject(carDetailViewModel)`
    - Show `ProgressView` when `viewModel.isLoadingFuelEntriesByCarID && viewModel.fuelEntriesByCarID.isEmpty`
    - Show error message + "Retry" `Button` when `viewModel.errorMessageFuelEntriesByCarID != nil`
    - Show empty-state `Text` when list is empty and not loading
    - On `.onAppear` of the last row, if `viewModel.hasNextPageFuelEntriesByID`, call `viewModel.loadNextPage(carID: carID)`
    - Show a bottom `ProgressView` when `viewModel.isLoadingNextPage`
    - Receive `@EnvironmentObject var carDetailViewModel: CarDetailViewModel` and pass it down to `FuelEntryDetailView`
    - _Requirements: 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10_

- [x] 11. Add "See All" button to `FuelSummaryView`
  - [x] 11.1 Add a `NavigationLink` "See All" button to `recentFuelLogsHeader` in `FuelEntrySummary`
    - Place it between the "Recent Fuel Logs" label and the existing "+" button in the `HStack`
    - Destination: `AllFuelEntriesView(carID: carID, fuelRepository: fuelRepository, fuelEntryRepository: repository).environmentObject(carDetailViewModel)`
    - Style: `Text("See All").font(.caption).fontWeight(.semibold)` (matching the design spec)
    - _Requirements: 2.1, 2.2_

- [x] 12. Build `CarEditSheet` modal
  - [x] 12.1 Create `Features/Car/View/CarDetailView/CarEditSheet.swift`
    - `@EnvironmentObject var viewModel: CarDetailViewModel` and `@Environment(\.dismiss) private var dismiss`
    - Render `TextField` fields bound to `viewModel.editForm` for all 10 car attributes (brand, model, manufactureYear, cylinderCapacity, vehicleIdentityNumber, engineNumber, color, fuelType, registrationYear, vehicleOwnershipDocumentNumber)
    - Add a "Save" `AppButton` that calls `viewModel.update(carID:)` — pass the car ID from `viewModel.car?.id.uuidString`; set `isLoading: viewModel.isUpdating` and disable when `viewModel.isUpdating`
    - Display `viewModel.errorMessageUpdate` as a red caption when non-nil
    - Add `.onChange(of: viewModel.didUpdateSuccessfully)` — when true, call `dismiss()`
    - _Requirements: 3.2, 3.3, 3.5, 3.7, 3.8, 3.9_

- [x] 13. Add edit button to `CarDetailCardView` and wire the sheet
  - [x] 13.1 Add `@EnvironmentObject var carDetailViewModel: CarDetailViewModel` to `CarDetailCardView`
    - The environment object is already injected by `CarDetailView` via `.environmentObject(viewModel)`
    - Add a pencil icon `Button` (e.g., `Image(systemName: "pencil.circle.fill")`) overlaid at the top-right corner of the `TabView` using `.overlay(alignment: .topTrailing)`
    - Tapping sets `carDetailViewModel.isShowingEditSheet = true`
    - Attach `.sheet(isPresented: $carDetailViewModel.isShowingEditSheet) { CarEditSheet().environmentObject(carDetailViewModel) }` to the root `VStack`
    - _Requirements: 3.1, 3.2_

- [x] 14. Checkpoint — Ensure all three feature areas compile and render correctly in Xcode Previews
  - Ensure all tests pass, ask the user if questions arise.

- [x] 15. Wire new views in `AppContainer` and verify DI
  - [x] 15.1 Verify `AppContainer` already exposes `carRepository`, `fuelRepository`, and `fuelEntryRepository` as the correct concrete types
    - No new lazy properties are needed; `AllFuelEntriesView` and `CarEditSheet` receive repositories via constructor injection from `CarDetailView` / `FuelSummaryView`, which already receive them from `RootView` → `CarListView` → `CarDetailView`
    - Confirm the `CarDetailView` init signature still compiles after `CarDetailViewModel` gains new published properties
    - _Requirements: 2.2, 3.2_

- [x] 16. Final checkpoint — Ensure all tests pass and the full feature is integrated
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for a faster MVP
- Property-based tests use [SwiftCheck](https://github.com/typelift/SwiftCheck) and require the package to be added to the project before running
- Each property test is tagged with `// Feature: car-journal-editable-views, Property N: <text>` for traceability
- `FuelEntryUpdateRequest.filledAt` is a `String` (ISO 8601); `FuelEntryEditForm.toUpdateRequest` must format the `Date` accordingly
- The `odometerReading` field in `FuelEntryEditForm` defaults to `""` because `FuelEntryResponse` does not expose the raw odometer value — the user must enter it manually (known API gap documented in the design)
- `CarEditSheet` reads the car ID from `viewModel.car?.id.uuidString`; the sheet button should be disabled until `viewModel.car` is non-nil
