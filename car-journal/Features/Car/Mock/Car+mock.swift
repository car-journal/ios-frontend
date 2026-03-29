//
//  Car+mock.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

extension CarDetailResponse {
    static let mockCar: CarDetailResponse = CarDetailResponse (
        id: UUID(),
        createdAt: Date(),
        updatedAt: Date(),
        deletedAt: nil,
        userId: UUID(),
        brand: "Toyota",
        model: "Corolla",
        manufactureYear: 2020,
        cylinderCapacity: 1800,
        vehicleIdentityNumber: nil,
        engineNumber: nil,
        color: "Black",
        fuelType: "Petrol",
        registrationYear: nil,
        vehicleOwnershipDocumentNumber: nil,
        averageFuelConsumptionRate: 7.5,
        recentFuelEntries: mockRecentFuelEntries
    )
    
    static let mockRecentFuelEntries: [FuelEntry] = [
        FuelEntry (
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
        FuelEntry (
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
        FuelEntry (
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
        FuelEntry (
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
        FuelEntry (
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

extension CarListResponse {
    static let mockCar: CarListResponse = CarListResponse (
        id: UUID(),
        createdAt: Date(),
        updatedAt: Date(),
        deletedAt: nil,
        brand: "Toyota",
        model: "Corolla",
        manufactureYear: 2020,
        cylinderCapacity: 1800,
        color: "Black",
        fuelType: "Petrol",
        averageFuelConsumptionRate: 7.5,
    )
    
    static let mockCarsFirstPage: [CarListResponse] = [
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Toyota",
            model: "Corolla",
            manufactureYear: 2020,
            cylinderCapacity: 1800,
            color: "Black",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 7.5
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Honda",
            model: "Civic",
            manufactureYear: 2021,
            cylinderCapacity: 1500,
            color: "White",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 6.8
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "BMW",
            model: "320i",
            manufactureYear: 2019,
            cylinderCapacity: 2000,
            color: "Blue",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 7.9
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Ford",
            model: "Everest",
            manufactureYear: 2012,
            cylinderCapacity: 2499,
            color: "Black",
            fuelType: "Diesel",
            averageFuelConsumptionRate: 7.9
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "BMW",
            model: "320i",
            manufactureYear: 2019,
            cylinderCapacity: 2000,
            color: "Blue",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 7.9
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Ford",
            model: "Everest",
            manufactureYear: 2012,
            cylinderCapacity: 2499,
            color: "Black",
            fuelType: "Diesel",
            averageFuelConsumptionRate: 7.9
        )
    ]
    
    static let mockCarsSecondPage: [CarListResponse] = [
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Toyota",
            model: "Corolla",
            manufactureYear: 2020,
            cylinderCapacity: 1800,
            color: "Black",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 7.5
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Honda",
            model: "Civic",
            manufactureYear: 2021,
            cylinderCapacity: 1500,
            color: "White",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 6.8
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "BMW",
            model: "320i",
            manufactureYear: 2019,
            cylinderCapacity: 2000,
            color: "Blue",
            fuelType: "Petrol",
            averageFuelConsumptionRate: 7.9
        ),
        CarListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "Ford",
            model: "Everest",
            manufactureYear: 2012,
            cylinderCapacity: 2499,
            color: "Black",
            fuelType: "Diesel",
            averageFuelConsumptionRate: 7.9
        )
    ]
}
