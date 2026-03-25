//
//  LoginRequest.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let passwordConfirmation: String
    let clientSecret: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case passwordConfirmation = "password_confirmation"
        case clientSecret = "client_secret"
    }
}
