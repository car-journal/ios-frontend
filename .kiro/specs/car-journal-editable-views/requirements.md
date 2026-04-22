# Requirements Document

## Introduction

This feature adds editing capabilities to the Car Journal iOS app across three areas:

1. **Editable Fuel Entry Detail** — converts the existing read-only `FuelEntryDetailView` into an editable form that saves changes via `PATCH /v1/internal/fuel-entries/:fuel_entry_id`. The fuel name field reuses the existing `FuelNameDropdown` component backed by `GET /v1/internal/fuels`.
2. **All Fuel Entries List** — adds a "See All" button to the Fuel Summary section header on the Car Detail page, opening a new paginated list of all fuel entries for that car. Each row navigates to the editable Fuel Entry Detail page.
3. **Editable Car Detail Cards** — makes the two swipeable info cards on the Car Detail page editable in-place via a sheet, saving changes via `PATCH /v1/internal/cars/:car_id`.

The app follows an MVVM architecture with protocol-based repositories (`CarRepositoryProtocol`, `FuelEntryRepositoryProtocol`, `FuelRepositoryProtocol`), async/await networking through `APIClient`, and SwiftUI views with `@StateObject` / `@EnvironmentObject` view models.

---

## Glossary

- **App**: The Car Journal iOS application.
- **FuelEntryDetailView**: The SwiftUI view that displays details of a single fuel entry.
- **FuelEntryEditForm**: The editable form state used when editing a fuel entry, analogous to `FuelEntryForm` used for creation.
- **FuelEntryViewModel**: The `ObservableObject` view model shared across fuel entry views.
- **FuelNameDropdown**: The existing searchable dropdown component that queries `GET /v1/internal/fuels`.
- **CarDetailView**: The SwiftUI view that displays car information and fuel summary.
- **CarDetailCardView**: The swipeable two-card component inside `CarDetailView` showing car attributes.
- **CarEditSheet**: The sheet presented from `CarDetailCardView` for in-place editing of car details.
- **CarDetailViewModel**: The `ObservableObject` view model for `CarDetailView`.
- **AllFuelEntriesView**: The new SwiftUI view listing all fuel entries for a given car.
- **FuelEntryRepository**: The protocol `FuelEntryRepositoryProtocol` and its implementations.
- **CarRepository**: The protocol `CarRepositoryProtocol` and its implementations.
- **MutationResponse**: The API response type `{ success: Bool }` returned by PATCH endpoints.
- **PaginatedResponse**: The generic API response type wrapping a `data` array and `meta` pagination info.
- **Bearer Token**: The JWT access token retrieved via `AuthManager.requireAccessToken()` and sent in the `Authorization` header.

---

## Requirements

### Requirement 1: Editable Fuel Entry Detail Form

**User Story:** As a user, I want to edit an existing fuel entry directly from its detail page, so that I can correct mistakes without deleting and recreating the entry.

#### Acceptance Criteria

1. WHEN the Fuel Entry Detail page loads, THE FuelEntryDetailView SHALL pre-populate all form fields with the values from the fetched `FuelEntryResponse`.
2. THE FuelEntryDetailView SHALL render editable fields for: odometer reading, reading unit, fuel type, fuel brand, fuel name, fuel price, fuel unit, distance traveled, volume filled, filled-at date, and notes.
3. THE FuelEntryDetailView SHALL render the fuel name field using the FuelNameDropdown component, allowing the user to search and select a fuel by name.
4. WHEN the user selects a fuel from the FuelNameDropdown, THE FuelEntryDetailView SHALL automatically populate the fuel type, fuel brand, and fuel price fields with the values from the selected `FuelListResponse`.
5. WHEN the user taps the save button, THE FuelEntryViewModel SHALL validate that odometer reading is a non-empty integer, fuel price is a non-empty number, distance traveled is a number, volume filled is a number, and fuel type, fuel brand, and fuel name are non-empty strings.
6. IF validation fails, THEN THE FuelEntryDetailView SHALL display a descriptive error message and SHALL NOT submit the request.
7. WHEN validation passes and the user taps the save button, THE FuelEntryViewModel SHALL call `PATCH /v1/internal/fuel-entries/:fuel_entry_id` with a `FuelEntryUpdateRequest` body and a Bearer Token header.
8. WHEN the PATCH request returns `{ success: true }`, THE FuelEntryDetailView SHALL dismiss the view and THE CarDetailViewModel SHALL refresh the car detail data.
9. IF the PATCH request returns an error, THEN THE FuelEntryDetailView SHALL display a user-facing error message and SHALL remain on the edit page.
10. WHILE the PATCH request is in-flight, THE FuelEntryDetailView SHALL display a loading indicator on the save button and SHALL disable the save button to prevent duplicate submissions.

---

### Requirement 2: All Fuel Entries List Page

**User Story:** As a user, I want to see all fuel entries for a car in one place, so that I can browse my full refueling history beyond the recent entries shown on the Car Detail page.

#### Acceptance Criteria

1. THE CarDetailView SHALL display a "See All" button on the right side of the "Fuel Summary" section header, alongside the existing "+" add button.
2. WHEN the user taps the "See All" button, THE App SHALL navigate to the AllFuelEntriesView for the current car.
3. WHEN AllFuelEntriesView loads, THE FuelEntryViewModel SHALL call `GET /v1/internal/cars/:car_id/fuel-entries` with a Bearer Token header to fetch the first page of fuel entries.
4. THE AllFuelEntriesView SHALL render each fuel entry as a tappable row using the existing `FuelEntryCardComponentView` layout.
5. WHEN the user taps a fuel entry row, THE App SHALL navigate to the FuelEntryDetailView for that entry in edit mode.
6. WHILE the initial fuel entry list is loading, THE AllFuelEntriesView SHALL display a loading indicator.
7. IF the fetch request returns an error, THEN THE AllFuelEntriesView SHALL display a descriptive error message with a retry option.
8. WHEN the user scrolls to the last visible row and `PaginationMeta.hasNext` is `true`, THE FuelEntryViewModel SHALL fetch the next page and append the results to the existing list.
9. WHILE a pagination fetch is in-flight, THE AllFuelEntriesView SHALL display a loading indicator at the bottom of the list.
10. IF the fuel entry list is empty, THEN THE AllFuelEntriesView SHALL display an empty-state message indicating no fuel entries exist for the car.

---

### Requirement 3: Editable Car Detail Cards

**User Story:** As a user, I want to edit my car's information directly from the Car Detail page, so that I can keep the car's details accurate without navigating to a separate screen.

#### Acceptance Criteria

1. THE CarDetailCardView SHALL display an edit button (e.g., a pencil icon) accessible from the card area.
2. WHEN the user taps the edit button, THE CarDetailView SHALL present a CarEditSheet as a modal sheet containing editable fields for: brand, model, manufacture year, cylinder capacity, vehicle identity number, engine number, color, fuel type, registration year, and vehicle ownership document number.
3. WHEN the CarEditSheet opens, THE CarEditSheet SHALL pre-populate all fields with the current values from the loaded `CarDetailResponse`.
4. WHEN the user taps the save button in the CarEditSheet, THE CarDetailViewModel SHALL validate that brand, model, color, and fuel type are non-empty strings, and that manufacture year and cylinder capacity are positive integers.
5. IF validation fails, THEN THE CarEditSheet SHALL display a descriptive error message and SHALL NOT submit the request.
6. WHEN validation passes and the user taps the save button, THE CarDetailViewModel SHALL call `PATCH /v1/internal/cars/:car_id` with a `CarUpdateRequest` body and a Bearer Token header.
7. WHEN the PATCH request returns `{ success: true }`, THE CarEditSheet SHALL dismiss and THE CarDetailViewModel SHALL refresh the car detail data so the updated values are reflected in the cards.
8. IF the PATCH request returns an error, THEN THE CarEditSheet SHALL display a user-facing error message and SHALL remain open.
9. WHILE the PATCH request is in-flight, THE CarEditSheet SHALL display a loading indicator on the save button and SHALL disable the save button to prevent duplicate submissions.
10. THE CarRepository SHALL expose an `update(carID: String, payload: CarUpdateRequest)` method that calls `PATCH /v1/internal/cars/:car_id` and returns a `MutationResponse`.
