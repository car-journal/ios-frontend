//
//  AuthEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(email: String, password: String)
    case register(payload: RegisterRequest)
}

extension AuthEndpoint {
    var path: String {
        switch self {
        case .login:    return "/v1/external/auth/login"
        case .register: return "/v1/external/auth/register"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register: return .post
        }
    }

    var body: (any Encodable)? {
        switch self {
        case let .login(email, password):
            return LoginRequest(
                email: email,
                password: password,
                passwordConfirmation: password,
                clientSecret: AppConfig.clientSecret
            )
        case let .register(payload):
            return payload
        }
    }
}
