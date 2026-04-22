//
//  UpdateUserProfileRequest.swift
//  car-journal
//

import Foundation

struct UpdateUserProfileRequest: Encodable {
    let gender: String?
    let firstName: String
    let lastName: String?
    let dateOfBirth: String?
    let pictureUrl: String?
}
