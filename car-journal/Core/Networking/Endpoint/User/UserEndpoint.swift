//
//  UserEndpoint.swift
//  car-journal
//

import Foundation

enum UserEndpoint: Endpoint {
    case me(token: String)
    case updateProfile(payload: UpdateUserProfileRequest, token: String)
    case updatePassword(payload: UpdatePasswordRequest, token: String)
}

extension UserEndpoint {
    var path: String {
        switch self {
        case .me:              return "/v1/internal/auth/me"
        case .updateProfile:   return "/v1/internal/user-profiles"
        case .updatePassword:  return "/v1/internal/auth/update-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .me:             return .get
        case .updateProfile:  return .patch
        case .updatePassword: return .patch
        }
    }

    var headers: [String: String]? {
        let token: String
        switch self {
        case let .me(t),
             let .updateProfile(_, t),
             let .updatePassword(_, t):
            token = t
        }
        return ["Authorization": "Bearer \(token)"]
    }

    var body: (any Encodable)? {
        switch self {
        case let .updateProfile(payload, _):  return payload
        case let .updatePassword(payload, _): return payload
        default: return nil
        }
    }
}
