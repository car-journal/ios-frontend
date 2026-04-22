//
//  MaintenanceEntryUpdateRequest.swift
//  car-journal
//

import Foundation

struct MaintenanceEntryUpdateRequest: Encodable {
    let categoryId: String
    let odometerReading: Int
    let readingUnit: String
    let brand: String
    let name: String
    let price: Double
    let performedAt: String
    let notes: String?
}
