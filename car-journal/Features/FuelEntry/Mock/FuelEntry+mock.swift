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

extension FuelEntryResponse {
    static let mockFuelEntry = FuelEntryResponse(
        id: UUID(),
        createdAt: Date(),
        updatedAt: Date(),
        deletedAt: nil,
        carId: UUID(),
        odometerEntryId: UUID(),
        fuelType: "diesel",
        fuelBrand: "pertamina",
        fuelName: "solar",
        fuelPrice: 6800,
        fuelUnit: "liter",
        distanceTraveled: 369.5,
        volumeFilled: 46.5,
        totalPrice: 316200,
        fuelConsumption: 7.94,
        notes: nil,
    )
    
    static let mockFuelEntries: [FuelEntryResponse] = [
        FuelEntryResponse (
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            fuelType: "diesel",
            fuelBrand: "pertamina",
            fuelName: "solar",
            fuelPrice: 6800,
            fuelUnit: "liter",
            distanceTraveled: 369.5,
            volumeFilled: 46.5,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
        ),
        FuelEntryResponse (
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            fuelType: "diesel",
            fuelBrand: "pertamina",
            fuelName: "solar",
            fuelPrice: 6800,
            fuelUnit: "liter",
            distanceTraveled: 369.5,
            volumeFilled: 46.5,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
        ),
        FuelEntryResponse (
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            fuelType: "diesel",
            fuelBrand: "pertamina",
            fuelName: "solar",
            fuelPrice: 6800,
            fuelUnit: "liter",
            distanceTraveled: 369.5,
            volumeFilled: 46.5,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
        ),
        FuelEntryResponse (
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            fuelType: "diesel",
            fuelBrand: "pertamina",
            fuelName: "solar",
            fuelPrice: 6800,
            fuelUnit: "liter",
            distanceTraveled: 369.5,
            volumeFilled: 46.5,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
        ),
        FuelEntryResponse (
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            fuelType: "diesel",
            fuelBrand: "pertamina",
            fuelName: "solar",
            fuelPrice: 6800,
            fuelUnit: "liter",
            distanceTraveled: 369.5,
            volumeFilled: 46.5,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
        )
    ]
}
