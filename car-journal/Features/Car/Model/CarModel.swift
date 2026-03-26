//
//  CarModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

struct Car: Identifiable {
    let id: UUID
    let userID: UUID
    let brand: String
    let model: String
    let manufacture_year: String
    let cylinder_capacity: String
    let vehicle_identity_number: String
    let engine_number: String
    let color: String
    let fuel_type: String
    let registration_year: String
    let vehicle_ownership_document_number: String
    let created_at: Date
    let updated_at: Date
    let deleted_at: Date?
}
