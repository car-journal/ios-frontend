//
//  Maintenance+mock.swift
//  car-journal
//

import Foundation

extension MaintenanceEntryResponse {
    static let mockPerformedAt = ISO8601DateFormatter().date(from: "2026-04-06T15:44:00+07:00")!

    static let mockEntries: [MaintenanceEntryResponse] = [
        MaintenanceEntryResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            categoryId: UUID(),
            brand: "3M",
            name: "Window Tint",
            price: 5_000_000,
            performedAt: mockPerformedAt,
            notes: nil
        ),
        MaintenanceEntryResponse(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil,
            carId: UUID(),
            odometerEntryId: UUID(),
            categoryId: UUID(),
            brand: "Something",
            name: "Repaint",
            price: 50_000_000,
            performedAt: mockPerformedAt,
            notes: "Full body repaint"
        )
    ]
}

extension MaintenanceCategoryResponse {
    static let mockCategories: [MaintenanceCategoryResponse] = [
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Body & Exterior", description: "Focuses on environmental protection and the physical look of the car."),
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Chassis & Handling", description: "Includes everything under the car that manages movement, stopping, and safety."),
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Electrical & Tech", description: "Manages the power, lighting, and modern conveniences of the vehicle."),
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Interior & Comfort", description: "Everything inside the car that affects your driving experience."),
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Powertrain", description: "Focuses on the engine and transmission."),
        MaintenanceCategoryResponse(id: UUID(), createdAt: Date(), updatedAt: Date(), deletedAt: nil, name: "Support & Fluids", description: "Consumable liquids and cooling components.")
    ]
}
