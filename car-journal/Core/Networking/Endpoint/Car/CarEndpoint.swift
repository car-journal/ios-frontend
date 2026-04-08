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
    // TODO: create update case
//    case update(data)
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
        }
    }
    
    var headers: [String : String]? {
        let token: String
        
        switch self {
        case let .list(_, t),
             let .findByID(_, t),
             let .listOfFuelEntries(_, _, _, t):
            token = t
        }
        
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var body: (any Encodable)? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(page, _):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .findByID:
            return nil
        case .listOfFuelEntries:
            return nil
        }
    }
}
