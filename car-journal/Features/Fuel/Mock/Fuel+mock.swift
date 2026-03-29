//
//  Fuel+mock.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

extension FuelListResponse {
    static let mockFuels: [FuelListResponse] = [
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "petrol",
            name: "pertalite",
            price: 10000
        ),
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "petrol",
            name: "pertamax",
            price: 10000
        ),
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "petrol",
            name: "pertamax turbo",
            price: 10000
        ),
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "diesel",
            name: "biosolar",
            price: 10000
        ),
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "diesel",
            name: "dexlite",
            price: 10000
        ),
        FuelListResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            brand: "pertamina",
            type: "diesel",
            name: "dex",
            price: 10000
        )
    ]
}
