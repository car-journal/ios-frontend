//
//  FuelEntry+mock.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

extension FuelEntryCreateRequest {
    static let mockFilledAt = ISO8601DateFormatter().date(from: "2023-11-30T00:00:00Z")!
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
        filledAt: mockFilledAt,
        notes: nil
    )
}

extension FuelEntryResponse {
    static let mockFilledAt = ISO8601DateFormatter().date(from: "2023-11-30T00:00:00Z")!
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
        filledAt: mockFilledAt,
        totalPrice: 316200,
        fuelConsumption: 7.94,
        notes: nil,
        odometerReading: 490
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
            filledAt: mockFilledAt,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
            odometerReading: 490
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
            filledAt: mockFilledAt,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
            odometerReading: 490
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
            filledAt: mockFilledAt,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
            odometerReading: 490
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
            filledAt: mockFilledAt,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
            odometerReading: 490
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
            filledAt: mockFilledAt,
            totalPrice: 316200,
            fuelConsumption: 7.94,
            notes: nil,
            odometerReading: 490
        )
    ]
}
