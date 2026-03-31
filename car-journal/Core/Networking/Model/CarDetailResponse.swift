//
//  CarDetailResponse.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 27/03/26.
//

import Foundation

struct CarDetailResponse: Decodable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let userId: UUID
    let brand: String
    let model: String
    let manufactureYear: Int
    let cylinderCapacity: Int
    let vehicleIdentityNumber: String?
    let engineNumber: String?
    let color: String
    let fuelType: String
    let registrationYear: String?
    let vehicleOwnershipDocumentNumber: String?
    let fuelSummary: FuelSummary
}

struct FuelSummary: Decodable, Equatable {
    let averageFuelConsumptionRate: Double
    let fuelConsumptionRateTrend: Double?
    let recentFuelEntries: [FuelEntry]
}

struct FuelEntry: Decodable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let carId: UUID
    let odometerEntryId: UUID
    let fuelType: String
    let fuelBrand: String
    let fuelName: String
    let fuelPrice: Int
    let fuelUnit: String
    let distanceTraveled: Double
    let volumeFilled: Double
    let totalPrice: Decimal
    let fuelConsumption: Double
    let notes: String?
}
