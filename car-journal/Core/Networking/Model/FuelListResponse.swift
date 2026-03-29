//
//  FuelListResponse.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

struct FuelListResponse: Decodable, Identifiable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let brand: String
    let type: String
    let name: String
    let price: Double
}
