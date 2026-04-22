//
//  UpdatePasswordRequest.swift
//  car-journal
//

import Foundation

struct UpdatePasswordRequest: Encodable {
    let oldPassword: String
    let newPassword: String
    let newPasswordConfirmation: String
}
