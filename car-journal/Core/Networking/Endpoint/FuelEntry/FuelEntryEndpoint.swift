//
//  CarEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

enum FuelEntryEndpoint: Endpoint {
    case create(payload: FuelEntryCreateRequest, token: String)
}

extension FuelEntryEndpoint {
    var path: String {
        switch self {
        case .create:
            return "/v1/internal/fuel-entries"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .create(_, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .create(payload, _):
            return payload
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
