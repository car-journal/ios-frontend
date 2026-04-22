//
//  FuelEntryEditForm.swift
//  car-journal
//
//  Created by Kiro on 21/04/26.
//

import Foundation

struct FuelEntryEditForm {
    var odometerReading: String = ""
    var readingUnit: String = "km"
    var fuelType: String = ""
    var fuelBrand: String = ""
    var fuelName: String = ""
    var fuelPrice: String = ""
    var fuelUnit: String = "liter"
    var distanceTraveled: String = ""
    var volumeFilled: String = ""
    var filledAt: Date = Date()
    var notes: String = ""
}

extension FuelEntryEditForm {
    init(from response: FuelEntryResponse) {
        self.odometerReading = response.odometerReading.map { String(format: "%g", NSDecimalNumber(decimal: $0).doubleValue) } ?? ""
        self.readingUnit = "km"
        self.fuelType = response.fuelType
        self.fuelBrand = response.fuelBrand
        self.fuelName = response.fuelName
        self.fuelPrice = String(format: "%g", NSDecimalNumber(decimal: response.fuelPrice).doubleValue)
        self.fuelUnit = response.fuelUnit
        self.distanceTraveled = String(response.distanceTraveled)
        self.volumeFilled = String(response.volumeFilled)
        self.filledAt = response.filledAt
        self.notes = response.notes ?? ""
    }
}

extension FuelEntryEditForm {
    func validate() -> String? {
        if odometerReading.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Odometer is required"
        }
        if Int(odometerReading) == nil {
            return "Odometer must be a number"
        }
        if fuelPrice.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Fuel price is required"
        }
        if Double(fuelPrice) == nil {
            return "Fuel price must be a number"
        }
        if Double(distanceTraveled) == nil {
            return "Distance must be a number"
        }
        if Double(volumeFilled) == nil {
            return "Volume must be a number"
        }
        if fuelType.isEmpty || fuelBrand.isEmpty || fuelName.isEmpty {
            return "Fuel information is incomplete"
        }
        return nil
    }
}

extension FuelEntryEditForm {
    func toUpdateRequest(carID: String) -> FuelEntryUpdateRequest {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        return FuelEntryUpdateRequest(
            odometerReading: Int(odometerReading) ?? 0,
            readingUnit: readingUnit,
            carID: carID,
            fuelType: fuelType,
            fuelBrand: fuelBrand,
            fuelName: fuelName,
            fuelPrice: Double(fuelPrice) ?? 0,
            fuelUnit: fuelUnit,
            distanceTraveled: Double(distanceTraveled) ?? 0,
            volumeFilled: Double(volumeFilled) ?? 0,
            filledAt: formatter.string(from: filledAt),
            notes: notes.isEmpty ? nil : notes
        )
    }
}
