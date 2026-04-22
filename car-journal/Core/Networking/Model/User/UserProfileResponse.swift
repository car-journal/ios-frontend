//
//  UserProfileResponse.swift
//  car-journal
//

import Foundation

struct UserProfileResponse: Decodable, Equatable {
    let id: UUID
    let roleId: String
    let email: String
    let createdAt: Date
    let updatedAt: Date
    let firstName: String
    let lastName: String?
    let pictureUrl: String?
}
