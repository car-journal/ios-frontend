# Design Document: car-journal-editable-views

## Overview

This feature adds editing capabilities to three areas of the Car Journal iOS app:

1. **Editable Fuel Entry Detail** — converts the read-only `FuelEntryDetailView` into an in-place editable form backed by `PATCH /v1/internal/fuel-entries/:fuel_entry_id`.
2. **All Fuel Entries List** — adds a "See All" button to the Fuel Summary section that opens a new paginated `AllFuelEntriesView`, with each row navigating to the editable detail.
3. **Editable Car Detail Cards** — adds an edit button to `CarDetailCardView` that opens a `CarEditSheet` modal, saving via `PATCH /v1/internal/cars/:car_id`.

All three areas follow the existing MVVM + protocol-based repository pattern with async/await networking through `APIClient`.

---

## Architecture

The app uses a layered MVVM architecture:

```
View  ──▶  ViewModel (@MainActor ObservableObject)
               │
               ▼
          Repository (protocol)
               │
               ▼
          RepositoryImpl  ──▶  APIClient  ──▶  URLSession
                                    │
                                    ▼
                               Endpoint (enum)
```

**Key conventions observed in the codebase:**
- Views receive repositories as constructor parameters (no `@EnvironmentObject` for repositories).
- `CarDetailViewModel` is injected into child views via `.environmentObject(viewModel)` from `CarDetailView`.
- `@StateObject` is used for view-owned view models; `@EnvironmentObject` for shared parent view models.
- Endpoints are `enum` cases conforming to the `Endpoint` protocol, grouped by domain (`CarEndpoint`, `FuelEntryEndpoint`, etc.).
- `AuthManager.requireAccessToken()` is called inside repository implementations to attach the Bearer token.
- `MutationResponse` (`{ success: Bool }`) is the return type for all mutating endpoints.
- `PaginatedResponse<T>` wraps list responses with a `PaginationMeta` containing `hasNext`, `lastPage`, etc.
- Form state is modelled as a separate `struct` (e.g., `FuelEntryForm`) with `validate()` and `toRequest()` methods.

---

## Components and Interfaces

### 1. Editable Fuel Entry Detail

#### `FuelEntryEditForm` (new model)

A new form struct mirroring `FuelEntryForm` but pre-populated from a `FuelEntryResponse`. Placed at `Features/FuelEntry/Model/FuelEntryEditForm.swift`.

```swift
struct FuelEntryEditForm {
    var odometerReading: String
    var readingUnit: String
    var fuelType: String
    var fuelBrand: String
    var fuelName: String
    var fuelPrice: String
    var fuelUnit: String
    var distanceTraveled: String
    var volumeFilled: String
    var filledAt: Date
    var notes: String

    init(from response: FuelEntryResponse) { ... }
    func validate() -> String?
    func toUpdateRequest(carID: String, fuelEntryID: String) -> FuelEntryUpdateRequest
}
```

`init(from:)` maps each `FuelEntryResponse` field to its string representation. `validate()` reuses the same rules as `FuelEntryForm.validate()`. `toUpdateRequest` converts the form to `FuelEntryUpdateRequest`.

#### `FuelEntryViewModel` (extended)

Add the following to the existing `FuelEntryViewModel`:

```swift
@Published var editForm = FuelEntryEditForm()
@Published var isUpdating = false
@Published var didUpdateSuccessfully = false
@Published var errorMessageUpdate: String?

func update(fuelEntryID: String) async
```

`update(fuelEntryID:)` validates `editForm`, calls `repository.update(fuelEntryID:payload:)`, and sets `didUpdateSuccessfully` or `errorMessageUpdate`.

When `findByID` completes successfully, `editForm` is populated from the fetched `FuelEntryResponse`.

#### `FuelEntryRepositoryProtocol` (extended)

```swift
func update(fuelEntryID: String, payload: FuelEntryUpdateRequest) async throws -> MutationResponse
```

#### `FuelEntryRepositoryImpl` (extended)

Calls `FuelEntryEndpoint.update(fuelEntryID:payload:token:)`.

#### `FuelEntryEndpoint` (extended)

```swift
case update(fuelEntryID: String, payload: FuelEntryUpdateRequest, token: String)
// path: PATCH /v1/internal/fuel-entries/:fuel_entry_id
```

#### `FuelEntryDetailView` (modified)

Converted from read-only display to an editable form. The view:
- Shows form fields bound to `viewModel.editForm` (same fields as `FuelEntryCreateView`).
- Uses `FuelNameDropdown` for the fuel name field, which auto-populates `fuelType`, `fuelBrand`, and `fuelPrice` on selection.
- Shows a "Save" button that calls `viewModel.update(fuelEntryID:)`.
- Displays `viewModel.errorMessageUpdate` when set.
- Shows a loading indicator on the save button when `viewModel.isUpdating` is true and disables the button.
- On `didUpdateSuccessfully`, calls `carDetailViewModel.refresh(carID:)` and dismisses.

The view still uses `@EnvironmentObject var carDetailViewModel: CarDetailViewModel` (same pattern as `FuelEntryCreateView`).

---

### 2. All Fuel Entries List

#### `AllFuelEntriesView` (new view)

Placed at `Features/FuelEntry/View/AllFuelEntriesView.swift`.

```swift
struct AllFuelEntriesView: View {
    let carID: String
    let fuelRepository: FuelRepositoryProtocol
    let fuelEntryRepository: FuelEntryRepositoryProtocol
    @StateObject private var viewModel: FuelEntryViewModel
}
```

The view:
- On `.task`, calls `viewModel.listByCarID(carID:page:)` for page 1.
- Renders a `List` (or `LazyVStack`) of `FuelEntryCardComponentView` rows, each wrapped in a `NavigationLink` to `FuelEntryDetailView`.
- Shows a `ProgressView` while `viewModel.isLoadingFuelEntriesByCarID` is true and the list is empty.
- Shows an error message with a "Retry" button when `viewModel.errorMessageFuelEntriesByCarID` is set.
- Shows an empty-state message when the list is empty and not loading.
- Triggers pagination when the last row appears (using `.onAppear` on the last item) and `viewModel.hasNextPageFuelEntriesByID` is true.
- Shows a bottom `ProgressView` during pagination (a new `isLoadingNextPage` flag on the view model).

#### `FuelEntryViewModel` (extended for pagination)

Add:
```swift
@Published var isLoadingNextPage = false
```

Modify `listByCarID` to **append** results when `page > 1` instead of replacing. Add a `loadNextPage(carID:)` convenience method that increments `currentPageFuelEntriesByID` and calls `listByCarID`.

#### `FuelEntrySummary` / `FuelSummaryView` (modified)

The `recentFuelLogsHeader` in `FuelEntrySummary` gains a "See All" `NavigationLink` button alongside the existing "+" button:

```swift
NavigationLink {
    AllFuelEntriesView(carID: carID, fuelRepository: fuelRepository, fuelEntryRepository: repository)
        .environmentObject(carDetailViewModel)
} label: {
    Text("See All")
        .font(.caption)
        .fontWeight(.semibold)
}
```

---

### 3. Editable Car Detail Cards

#### `CarEditForm` (new model)

Placed at `Features/Car/Model/CarEditForm.swift`.

```swift
struct CarEditForm {
    var brand: String
    var model: String
    var manufactureYear: String
    var cylinderCapacity: String
    var vehicleIdentityNumber: String
    var engineNumber: String
    var color: String
    var fuelType: String
    var registrationYear: String
    var vehicleOwnershipDocumentNumber: String

    init(from response: CarDetailResponse) { ... }
    func validate() -> String?
    func toUpdateRequest() -> CarUpdateRequest
}
```

`validate()` checks that `brand`, `model`, `color`, and `fuelType` are non-empty, and that `manufactureYear` and `cylinderCapacity` parse as positive integers.

#### `CarDetailViewModel` (extended)

```swift
@Published var editForm = CarEditForm()
@Published var isUpdating = false
@Published var didUpdateSuccessfully = false
@Published var errorMessageUpdate: String?
@Published var isShowingEditSheet = false

func update(carID: String) async
```

When `findByID` completes, `editForm` is populated from the fetched `CarDetailResponse`. `update(carID:)` validates `editForm`, calls `repository.update(carID:payload:)`, and sets `didUpdateSuccessfully` or `errorMessageUpdate`.

#### `CarRepositoryProtocol` (extended)

```swift
func update(carID: String, payload: CarUpdateRequest) async throws -> MutationResponse
```

#### `CarRepositoryImpl` (extended)

Calls `CarEndpoint.update(carID:payload:token:)`.

#### `CarEndpoint` (extended)

```swift
case update(carID: String, payload: CarUpdateRequest, token: String)
// path: PATCH /v1/internal/cars/:car_id
// method: .patch (add .patch to HTTPMethod enum)
```

Note: `HTTPMethod` currently lacks `.patch`. Add `case patch = "PATCH"` to the enum.

#### `CarDetailCardView` (modified)

Receives `@EnvironmentObject var carDetailViewModel: CarDetailViewModel` (already available via `CarDetailView`'s `.environmentObject(viewModel)`).

Adds a pencil icon button overlaid on the card area (e.g., top-right corner of the `TabView`). Tapping sets `carDetailViewModel.isShowingEditSheet = true`.

```swift
.sheet(isPresented: $carDetailViewModel.isShowingEditSheet) {
    CarEditSheet()
        .environmentObject(carDetailViewModel)
}
```

#### `CarEditSheet` (new view)

Placed at `Features/Car/View/CarDetailView/CarEditSheet.swift`.

```swift
struct CarEditSheet: View {
    @EnvironmentObject var viewModel: CarDetailViewModel
    @Environment(\.dismiss) private var dismiss
}
```

The sheet:
- Renders `TextField` fields bound to `viewModel.editForm` for all car attributes.
- Shows a "Save" button that calls `viewModel.update(carID:)`.
- Displays `viewModel.errorMessageUpdate` when set.
- Shows a loading indicator on the save button when `viewModel.isUpdating` is true and disables the button.
- On `didUpdateSuccessfully`, dismisses the sheet (the `CarDetailView` will reflect updated data because `CarDetailViewModel` refreshes).

---

## Data Models

### `FuelEntryEditForm`

| Field | Type | Source |
|---|---|---|
| `odometerReading` | `String` | `FuelEntryResponse.odometerEntryId` (display only; actual odometer from API) |
| `readingUnit` | `String` | `FuelEntryUpdateRequest.readingUnit` |
| `fuelType` | `String` | `FuelEntryResponse.fuelType` |
| `fuelBrand` | `String` | `FuelEntryResponse.fuelBrand` |
| `fuelName` | `String` | `FuelEntryResponse.fuelName` |
| `fuelPrice` | `String` | `FuelEntryResponse.fuelPrice` (formatted as decimal string) |
| `fuelUnit` | `String` | `FuelEntryResponse.fuelUnit` |
| `distanceTraveled` | `String` | `FuelEntryResponse.distanceTraveled` |
| `volumeFilled` | `String` | `FuelEntryResponse.volumeFilled` |
| `filledAt` | `Date` | `FuelEntryResponse.filledAt` |
| `notes` | `String` | `FuelEntryResponse.notes ?? ""` |

> Note: `FuelEntryResponse` does not expose `odometerReading` directly (it exposes `odometerEntryId`). The `FuelEntryUpdateRequest` requires `odometerReading: Int`. The detail view will include an odometer reading field that the user must fill in (pre-populated from the existing `FuelEntryCreateView` pattern). This is a known gap in the current API response model — the field should be pre-populated if the API is extended to return it, but for now it defaults to empty and requires user input.

### `CarEditForm`

| Field | Type | Source |
|---|---|---|
| `brand` | `String` | `CarDetailResponse.brand` |
| `model` | `String` | `CarDetailResponse.model` |
| `manufactureYear` | `String` | `String(CarDetailResponse.manufactureYear)` |
| `cylinderCapacity` | `String` | `String(CarDetailResponse.cylinderCapacity)` |
| `vehicleIdentityNumber` | `String` | `CarDetailResponse.vehicleIdentityNumber ?? ""` |
| `engineNumber` | `String` | `CarDetailResponse.engineNumber ?? ""` |
| `color` | `String` | `CarDetailResponse.color` |
| `fuelType` | `String` | `CarDetailResponse.fuelType` |
| `registrationYear` | `String` | `CarDetailResponse.registrationYear ?? ""` |
| `vehicleOwnershipDocumentNumber` | `String` | `CarDetailResponse.vehicleOwnershipDocumentNumber ?? ""` |

### `MockCarRepository` (extended)

Add `update(carID:payload:)` returning `MutationResponse(success: true)`.

### `MockFuelEntryRepository` (extended)

Add `update(fuelEntryID:payload:)` returning `MutationResponse(success: true)`.

---

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system — essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: FuelEntryEditForm pre-population round-trip

*For any* `FuelEntryResponse`, initializing a `FuelEntryEditForm` from it should produce a form where each field value matches the corresponding field in the response (fuelType, fuelBrand, fuelName, fuelUnit, distanceTraveled, volumeFilled, filledAt, notes).

**Validates: Requirements 1.1**

---

### Property 2: FuelNameDropdown selection auto-populates form fields

*For any* `FuelListResponse`, after simulating a selection from the `FuelNameDropdown`, `viewModel.editForm.fuelType` should equal `fuel.type`, `viewModel.editForm.fuelBrand` should equal `fuel.brand`, and `viewModel.editForm.fuelPrice` should equal the decimal string representation of `fuel.price`.

**Validates: Requirements 1.4**

---

### Property 3: FuelEntryEditForm validation rejects invalid inputs

*For any* `FuelEntryEditForm` where at least one required field is invalid (empty odometer, non-integer odometer, empty/non-numeric fuel price, non-numeric distance, non-numeric volume, or empty fuel type/brand/name), `validate()` should return a non-nil error string.

**Validates: Requirements 1.5**

---

### Property 4: FuelEntryEditForm toUpdateRequest field mapping

*For any* valid `FuelEntryEditForm`, `toUpdateRequest(carID:fuelEntryID:)` should produce a `FuelEntryUpdateRequest` where each field exactly matches the corresponding parsed form field value (odometerReading as Int, fuelPrice as Double, distanceTraveled as Double, volumeFilled as Double, and string fields verbatim).

**Validates: Requirements 1.7**

---

### Property 5: Pagination append preserves order

*For any* two non-overlapping pages of `FuelEntryResponse` arrays (page 1 and page 2), after loading page 1 then loading page 2, `viewModel.fuelEntriesByCarID` should contain all items from page 1 followed by all items from page 2, with no items dropped or reordered.

**Validates: Requirements 2.8**

---

### Property 6: CarEditForm pre-population round-trip

*For any* `CarDetailResponse`, initializing a `CarEditForm` from it should produce a form where each field value matches the corresponding field in the response (brand, model, manufactureYear as string, cylinderCapacity as string, color, fuelType, and optional fields defaulting to empty string when nil).

**Validates: Requirements 3.3**

---

### Property 7: CarEditForm validation rejects invalid inputs

*For any* `CarEditForm` where at least one required field is invalid (empty brand, model, color, or fuelType; non-positive-integer manufactureYear or cylinderCapacity), `validate()` should return a non-nil error string.

**Validates: Requirements 3.4**

---

### Property 8: CarEditForm toUpdateRequest field mapping

*For any* valid `CarEditForm`, `toUpdateRequest()` should produce a `CarUpdateRequest` where each field exactly matches the corresponding parsed form field value (manufactureYear and cylinderCapacity as Int, string fields verbatim, optional fields as nil when empty).

**Validates: Requirements 3.6**

---

## Error Handling

| Scenario | Handling |
|---|---|
| `FuelEntryViewModel.update` — network error | Sets `errorMessageUpdate`; view displays it inline; save button re-enabled |
| `FuelEntryViewModel.update` — validation failure | Sets `errorMessage`; no network call made |
| `CarDetailViewModel.update` — network error | Sets `errorMessageUpdate`; sheet stays open; save button re-enabled |
| `CarDetailViewModel.update` — validation failure | Sets `errorMessageUpdate`; no network call made |
| `FuelEntryViewModel.listByCarID` — network error | Sets `errorMessageFuelEntriesByCarID`; `AllFuelEntriesView` shows error + retry button |
| `FuelEntryViewModel.listByCarID` — empty result | `fuelEntriesByCarID` is empty; `AllFuelEntriesView` shows empty-state message |
| `AuthManager.requireAccessToken` throws | Propagated as a network error through the repository; displayed as a generic error message |

All error states are cleared at the start of each new async operation (`errorMessage = nil` before the call).

---

## Testing Strategy

### Unit Tests

Unit tests cover specific examples, edge cases, and error conditions:

- `FuelEntryEditForm.init(from:)` — verify each field is correctly mapped from a known `FuelEntryResponse`.
- `FuelEntryEditForm.validate()` — verify each invalid field produces the correct error message; verify a fully valid form returns nil.
- `FuelEntryEditForm.toUpdateRequest(carID:fuelEntryID:)` — verify field mapping with a known form.
- `CarEditForm.init(from:)` — verify each field is correctly mapped from a known `CarDetailResponse`, including nil → empty string.
- `CarEditForm.validate()` — verify each invalid field produces the correct error message; verify a fully valid form returns nil.
- `CarEditForm.toUpdateRequest()` — verify field mapping with a known form.
- `FuelEntryViewModel.update` — mock repository returns success → `didUpdateSuccessfully = true`; mock throws → `errorMessageUpdate` is set.
- `CarDetailViewModel.update` — same pattern.
- `FuelEntryViewModel.listByCarID` page 2 — verify items are appended, not replaced.

### Property-Based Tests

Property-based tests use [SwiftCheck](https://github.com/typelift/SwiftCheck) (the standard PBT library for Swift). Each test runs a minimum of 100 iterations.

Each test is tagged with a comment in the format:
`// Feature: car-journal-editable-views, Property N: <property text>`

**Property 1** — `FuelEntryEditForm` pre-population round-trip  
Generate arbitrary `FuelEntryResponse` values; verify `FuelEntryEditForm(from:)` maps all fields correctly.

**Property 2** — `FuelNameDropdown` selection auto-populates form fields  
Generate arbitrary `FuelListResponse` values; simulate selection; verify `editForm.fuelType`, `editForm.fuelBrand`, `editForm.fuelPrice` match.

**Property 3** — `FuelEntryEditForm` validation rejects invalid inputs  
Generate arbitrary `FuelEntryEditForm` values with at least one invalid field; verify `validate()` returns non-nil.

**Property 4** — `FuelEntryEditForm.toUpdateRequest` field mapping  
Generate arbitrary valid `FuelEntryEditForm` values; verify `toUpdateRequest` produces a `FuelEntryUpdateRequest` with matching fields.

**Property 5** — Pagination append preserves order  
Generate two arbitrary arrays of `FuelEntryResponse`; simulate loading page 1 then page 2; verify the combined list equals page1 + page2.

**Property 6** — `CarEditForm` pre-population round-trip  
Generate arbitrary `CarDetailResponse` values; verify `CarEditForm(from:)` maps all fields correctly.

**Property 7** — `CarEditForm` validation rejects invalid inputs  
Generate arbitrary `CarEditForm` values with at least one invalid field; verify `validate()` returns non-nil.

**Property 8** — `CarEditForm.toUpdateRequest` field mapping  
Generate arbitrary valid `CarEditForm` values; verify `toUpdateRequest()` produces a `CarUpdateRequest` with matching fields.

### Integration Tests

- `FuelEntryRepositoryImpl.update` — verify the correct endpoint path, method (PATCH), and body are constructed.
- `CarRepositoryImpl.update` — same.
- `CarRepositoryProtocol` — verify the `update(carID:payload:)` method exists (smoke test for Requirement 3.10).
