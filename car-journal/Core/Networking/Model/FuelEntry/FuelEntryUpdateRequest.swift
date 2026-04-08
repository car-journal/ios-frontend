//
//  FuelEntryCreateRequest.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

struct FuelEntryUpdateRequest: Encodable {
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
    let filledAt: String
    let notes: String?
}
