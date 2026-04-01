//
//  FuelEntryCreateRequest.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

struct FuelEntryCreateRequest: Encodable {
    let odometerReading: Int
    let readingUnit: String
    let carID: String
    let fuelType: String
    let fuelBrand: String
    let fuelName: String
    let fuelPrice: Double
    let fuelUnit: String
    let distanceTraveled: Double
    let volumeFilled: Double
    let notes: String?
}

extension FuelEntryCreateRequest {
    func validate() -> Bool {
        odometerReading > 0 &&
        !readingUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fuelType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fuelBrand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fuelName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        fuelPrice > 0 &&
        !fuelUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        distanceTraveled > 0 &&
        volumeFilled > 0
    }
}
