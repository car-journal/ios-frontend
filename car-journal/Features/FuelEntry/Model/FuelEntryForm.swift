//
//  FuelEntryForm.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 07/04/26.
//

import Foundation

struct FuelEntryForm: Encodable {
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

extension FuelEntryForm {
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

extension FuelEntryForm {
    func toRequest(carID: String) -> FuelEntryCreateRequest {
        FuelEntryCreateRequest(
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
            filledAt: filledAt,
            notes: notes.isEmpty ? nil : notes
        )
    }
}
