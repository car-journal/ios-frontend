//
//  FuelEntry+mock.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

extension FuelEntryCreateRequest {
    static let mockFuelEntry: FuelEntryCreateRequest = FuelEntryCreateRequest(
        odometerReading: 28000,
        readingUnit: "km",
        carID: "",
        fuelType: "diesel",
        fuelBrand: "pertamina",
        fuelName: "solar",
        fuelPrice: 6800,
        fuelUnit: "liter",
        distanceTraveled: 369.5,
        volumeFilled: 46.5,
        notes: nil
    )
}
