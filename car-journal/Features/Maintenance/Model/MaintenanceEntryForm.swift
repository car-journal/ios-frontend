//
//  MaintenanceEntryForm.swift
//  car-journal
//

import Foundation

struct MaintenanceEntryForm {
    var categoryId: String = ""
    var categoryName: String = ""
    var odometerReading: String = ""
    var readingUnit: String = "km"
    var brand: String = ""
    var name: String = ""
    var price: String = ""
    var performedAt: Date = Date()
    var notes: String = ""
}

extension MaintenanceEntryForm {
    init(from response: MaintenanceEntryResponse) {
        self.categoryId = response.categoryId.uuidString
        self.odometerReading = response.odometerReading.map { String($0) } ?? ""
        self.readingUnit = "km"
        self.brand = response.brand
        self.name = response.name
        self.price = String(format: "%.0f", NSDecimalNumber(decimal: response.price).doubleValue)
        self.performedAt = response.performedAt
        self.notes = response.notes ?? ""
    }
}

extension MaintenanceEntryForm {
    func validate() -> String? {
        if categoryId.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Category is required"
        }
        if brand.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Brand is required"
        }
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Name is required"
        }
        if price.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Price is required"
        }
        if Double(price) == nil {
            return "Price must be a number"
        }
        return nil
    }
}

extension MaintenanceEntryForm {
    func toCreateRequest() -> MaintenanceEntryCreateRequest {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        return MaintenanceEntryCreateRequest(
            categoryId: categoryId,
            odometerReading: Int(odometerReading) ?? 0,
            readingUnit: readingUnit,
            brand: brand,
            name: name,
            price: Double(price) ?? 0,
            performedAt: formatter.string(from: performedAt),
            notes: notes.isEmpty ? nil : notes
        )
    }

    func toUpdateRequest() -> MaintenanceEntryUpdateRequest {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        return MaintenanceEntryUpdateRequest(
            categoryId: categoryId,
            odometerReading: Int(odometerReading) ?? 0,
            readingUnit: readingUnit,
            brand: brand,
            name: name,
            price: Double(price) ?? 0,
            performedAt: formatter.string(from: performedAt),
            notes: notes.isEmpty ? nil : notes
        )
    }
}
