//
//  CarListResponse.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

struct CarListResponse: Decodable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let brand: String
    let model: String
    let manufactureYear: Int
    let cylinderCapacity: Int
    let color: String
    let fuelType: String
    let averageFuelConsumptionRate: Double
}
