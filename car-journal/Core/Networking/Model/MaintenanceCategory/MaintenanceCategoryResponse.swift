//
//  MaintenanceCategoryResponse.swift
//  car-journal
//

import Foundation

struct MaintenanceCategoryResponse: Decodable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let name: String
    let description: String?
}
