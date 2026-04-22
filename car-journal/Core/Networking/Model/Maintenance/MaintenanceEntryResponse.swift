//
//  MaintenanceEntryResponse.swift
//  car-journal
//

import Foundation

struct MaintenanceEntryResponse: Decodable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let carId: UUID
    let odometerEntryId: UUID
    let categoryId: UUID
    let brand: String
    let name: String
    let price: Decimal
    let performedAt: Date
    let notes: String?
}
