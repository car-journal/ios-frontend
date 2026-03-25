//
//  LoginResponse.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let expiresAt: Date
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresAt = "expiresIn"
        case tokenType
    }
}
