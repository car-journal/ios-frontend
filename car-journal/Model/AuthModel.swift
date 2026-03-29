//
//  AuthModel.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let expiresAt: Date
    let tokenType: String
}
