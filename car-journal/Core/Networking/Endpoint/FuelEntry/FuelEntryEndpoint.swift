//
//  CarEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

enum FuelEntryEndpoint: Endpoint {
    case create(payload: FuelEntryCreateRequest, token: String)
    case findByID(fuelEntryID: String, token: String)
}

extension FuelEntryEndpoint {
    var path: String {
        switch self {
        case .create:
            return "/v1/internal/fuel-entries"
        case let .findByID(fuelEntryID, _):
            return "/v1/internal/fuel-entries/\(fuelEntryID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .findByID:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .create(_, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        case let .findByID(_, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .create(payload, _):
            return payload
        case .findByID:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
