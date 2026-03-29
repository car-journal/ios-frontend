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
}

extension CarEndpoint {
    var path: String {
        switch self {
        case .list:
            return "/v1/internal/cars"
        case let .findByID(carID, _):
            return "/v1/internal/cars/\(carID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .findByID:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .list(_, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        case let .findByID(_, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var body: Data? {
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
        }
    }
}
