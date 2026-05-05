//
//  RegisterRequest.swift
//  car-journal
//

import Foundation

struct RegisterRequest: Encodable {
    let clientSecret: String
    let email: String
    let password: String
    let confirmPassword: String
    let gender: Bool?       // true = male, false = female
    let firstName: String
    let lastName: String?
    let dateOfBirth: String? // ISO 8601

    enum CodingKeys: String, CodingKey {
        case clientSecret    = "client_secret"
        case email
        case password
        case confirmPassword = "confirm_password"
        case gender
        case firstName       = "first_name"
        case lastName        = "last_name"
        case dateOfBirth     = "date_of_birth"
    }
}
