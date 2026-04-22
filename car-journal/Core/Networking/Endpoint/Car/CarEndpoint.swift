//
//  CarEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

enum CarEndpoint: Endpoint {
    case list(page: Int, token: String)
    case findByID(carID: String, token: String)
    case listOfFuelEntries(carID: String, page: Int, limit: Int, token: String)
    case update(carID: String, payload: CarUpdateRequest, token: String)
}

extension CarEndpoint {
    var path: String {
        switch self {
        case .list:
            return "/v1/internal/cars"
        case let .findByID(carID, _):
            return "/v1/internal/cars/\(carID)"
        case let .listOfFuelEntries(carID, _, _, _):
            return "/v1/internal/cars/\(carID)/fuel-entries"
        case let .update(carID, _, _):
            return "/v1/internal/cars/\(carID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .findByID:
            return .get
        case .listOfFuelEntries:
            return .get
        case .update:
            return .patch
        }
    }
    
    var headers: [String : String]? {
        let token: String
        
        switch self {
        case let .list(_, t),
             let .findByID(_, t),
             let .listOfFuelEntries(_, _, _, t),
             let .update(_, _, t):
            token = t
        }
        
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var body: (any Encodable)? {
        switch self {
        case let .update(_, payload, _):
            return payload
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(page, _):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .findByID:
            return nil
        case let .listOfFuelEntries(_, page, limit, _):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .update:
            return nil
        }
    }
}
